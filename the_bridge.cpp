#include <iostream>
#include <string>
#include <vector>
#include <algorithm>
#include <utility>
#include <memory> 

using namespace std;

enum class Action { Speed, Wait, Jump, Up, Down, Slow };

static const char HOLE = '0';
static const int DEBUG = 0;

static int race_target = 0;
static std::vector<int> race_track_orig;
static std::vector<int> race_track;

void debugPrintTrack( ostream& os ) {
    os << "RaceTrack( ";
    for ( const auto& elem : race_track_orig ) {
        os << elem << " ";
    }
    os << ")";
    os << std::endl;
}

//SPEED, SLOW, JUMP, WAIT, UP, DOWN.

std::string toString( Action action ) {
    switch( action ) {
        case Action::Wait:
            return "WAIT";
            break;
        case Action::Jump:
            return "JUMP";
            break;
        case Action::Up:
            return "UP";
            break;
        case Action::Down:
            return "DOWN";
            break;
        case Action::Speed:
            return "SPEED";
            break;
        case Action::Slow:
            return "SLOW";
            break;
       }
}

void debugPrint( ostream& os, std::vector<Action> actions ) {
    os << "Actions(";
    for ( const auto& elem : actions ) {
        os << toString( elem ) << " ";
    }
    os << ")" << std::endl;
}

class State {
public:
    // invalid state
    State() : x_(0), ymask_(0), speed_(0) {}
    
    // copy ctor
    State( const State& other )
     : x_( other.x_ ),
       ymask_( other.ymask_ ),
       speed_( other.speed_ ) {}

    State( int x, int ymask, int speed )
     : x_(x), ymask_(ymask), speed_(speed) {}

    int alive() const {
        return static_cast<int>( (ymask_ & 1) > 0 )
               + static_cast<int>( (ymask_ & 2) > 0 )
               + static_cast<int>( (ymask_ & 4) > 0 )
               + static_cast<int>( (ymask_ & 8) > 0 );
    }
    
    bool valid() const {
        return ymask_ && alive() >= race_target;
    }
    
    bool won() const {
        return valid() && x_ >= race_track_orig.size();
    }
    
    void debug_print( ostream& os ) const {
        os << "State(x:" << x_ << ",ymask:"
            << ( ymask_ & 1 ? "X" : "." )
            << ( ymask_ & 2 ? "X" : "." )
            << ( ymask_ & 4 ? "X" : "." )
            << ( ymask_ & 8 ? "X" : "." )
            << ",speed:" << speed_ << ")" << std::endl;
    }
    State get_next_state( Action a ) const {
        switch ( a ) {
            case Action::Wait:
                if ( speed_ == 0 ) {
                    return State();
                } else {
                    int nextx = x_ + speed_;
                    int nextmask = kill_bikes( ymask_, x_, nextx );
                    return State( nextx, nextmask, speed_ );
                }
                break;
            case Action::Up:
                if ( speed_ == 0
                    || ( ymask_ & 1 ) ) {
                    return State();
                } else {
                    int nextx = x_ + speed_;
                    int nextmask = kill_bikes( ymask_, x_, nextx - 1 );
                    nextmask = nextmask >> 1;
                    nextmask = kill_bikes( nextmask, x_, nextx );
                    return State( nextx, nextmask, speed_ );
                }
                break;
            case Action::Down:
                if ( speed_ == 0
                    || ymask_ > 7 ) {
                    return State();
                } else {
                    int nextx = x_ + speed_;
                    int nextmask = kill_bikes( ymask_, x_, nextx - 1 );
                    nextmask = nextmask << 1;
                    nextmask = kill_bikes( nextmask, x_, nextx );
                    return State( nextx, nextmask, speed_ );
                }
                break;
            case Action::Slow:
                if ( speed_ <= 1 ) {
                    return State();
                } else {
                    int nextspeed = speed_ - 1;
                    int nextx = x_ + nextspeed;
                    int nextmask = kill_bikes( ymask_, x_, nextx );
                    return State( nextx, nextmask, nextspeed );
                }
                break;
            case Action::Speed:
                {
                    int nextspeed = speed_ + 1;
                    int nextx = x_ + nextspeed;
                    int nextmask = kill_bikes( ymask_, x_, nextx );
                    return State( nextx, nextmask, nextspeed );
                }
                break;
            case Action::Jump:
                if ( speed_ == 0 ) {
                    return State();
                } else {
                    int nextx = x_ + speed_;
                    int nextmask = kill_bikes( ymask_, nextx - 1, nextx );
                    return State( nextx, nextmask, speed_ );
                }
                break;
        }
    }
private:
    int kill_bikes( int mask, int x1, int x2 ) const {
        for ( int x = x1 + 1; x <= x2; ++x ) {
            mask = mask & ( ~race_track[x] );
        }
        return mask;
    }
    int x_;
    int ymask_;
    int speed_;
};

class DfsPredictor
{
public:
    DfsPredictor( const State& state, bool maxi = false ) : state_( state ), maxi_( maxi ) {
        actions_.reserve(128);
        dfs_search( state );
    }
    std::vector<Action> get_actions() const {
        return actions_;
    }
private:
    bool dfs_search( const State& state, int level = 0 ) {
        if ( DEBUG ) {
            for ( int j = 0; j < level; ++j ) {
                cerr << "  ";
            }
            cerr << "=== dfs_search, " << state.alive() << " ";
            state.debug_print( cerr );
        }
        if ( maxi_ && state.alive() < 4 ) {
            return false;
        }
        
        if ( !state.valid() ) {
            return false;
        }
        if ( state.won() ) {
            return true;
        }
        for ( int i = 0; i < 6; ++i ) {
            Action action = static_cast<Action>( i );
            if ( dfs_search( state.get_next_state( action ), level + 1 ) ) {
                actions_.push_back( action );
                return true;
            }
        }
        return false;
    }
    State state_;
    bool maxi_;
    std::vector<Action> actions_;
};

static unique_ptr<State> game_state;
static unique_ptr<DfsPredictor> dfsp;

std::vector<Action> game_actions;

int main()
{
    int M; // the amount of motorbikes to control
    cin >> M; cin.ignore();
    int V; // the minimum amount of motorbikes that must survive
    cin >> V; cin.ignore();
    race_target = V;
    if ( DEBUG ) {
        cerr << "---> target is " << race_target << std::endl;
    }
    string L0; // L0 to L3 are lanes of the road. A dot character . represents a safe space, a zero 0 represents a hole in the road.
    cin >> L0; cin.ignore();
    string L1;
    cin >> L1; cin.ignore();
    string L2;
    cin >> L2; cin.ignore();
    string L3;
    cin >> L3; cin.ignore();
    
    for ( int i = 0; i < L0.length(); i++ ) {
        int ymask = static_cast<int>( L0.at(i) == HOLE )
                    + 2 * static_cast<int>( L1.at(i) == HOLE )
                    + 4 * static_cast<int>( L2.at(i) == HOLE )
                    + 8 * static_cast<int>( L3.at(i) == HOLE );
        race_track.push_back( ymask );
    }
    race_track_orig = race_track;
    for ( int i = 0; i < 16; ++i ) {
        race_track.push_back( 0 );
    }
    
    if ( DEBUG ) {
       debugPrintTrack( cerr );
    }
    
    // game loop
    while (1) {
        int S; // the motorbikes' speed
        cin >> S; cin.ignore();
        int commonX = 0;
        int ymask = 0;
        for (int i = 0; i < M; i++) {
            int X; // x coordinate of the motorbike
            int Y; // y coordinate of the motorbike
            int A; // indicates whether the motorbike is activated "1" or detroyed "0"
            cin >> X >> Y >> A; cin.ignore();
            commonX = X;
            
            if ( A ) {
                switch ( Y ) {
                    case 0:
                        ymask = ymask | 1;
                        break;
                    case 1:
                        ymask = ymask | 2;
                        break;
                    case 2:
                        ymask = ymask | 4;
                        break;
                    case 3:
                        ymask = ymask | 8;
                        break;
                }
            }
        }
        
        State iState(commonX, ymask, S);
        if ( DEBUG ) {
            cerr << "---> ";
            iState.debug_print( cerr );
        }
        
        if ( !game_state.get() ) {
            game_state.reset( new State( iState ) );
            if ( DEBUG ) {
               game_state->debug_print( cerr );
            }
            dfsp.reset( new DfsPredictor( *game_state, true ) );
            if ( dfsp->get_actions().empty() ) {
                dfsp.reset( new DfsPredictor( *game_state ) );
            }
            if ( DEBUG ) {
               debugPrint( cerr, dfsp->get_actions() );
            }
            game_actions = dfsp->get_actions();
        }
 
        // Write an action using cout. DON'T FORGET THE "<< endl"
        // To debug: cerr << "Debug messages..." << endl;


        // A single line containing one of 6 keywords: SPEED, SLOW, JUMP, WAIT, UP, DOWN.
        if ( game_actions.size() > 0 ) {
            cout << toString( game_actions[ game_actions.size() - 1 ] ) << std::endl;
            game_actions.pop_back();
        } else {
            cout << "WAIT" << std::endl;
        }
    }
}
