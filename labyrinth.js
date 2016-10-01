
var inputs = readline().split(' ');
var R = parseInt(inputs[0]); // number of rows.
var C = parseInt(inputs[1]); // number of columns.
var A = parseInt(inputs[2]); // number of rounds between the time the alarm countdown is activated and the time the alarm goes off.

var map_adjacency_lista = {};
var map_parentsa = {};
var map_radius = 0;
var map_constraint = "noc";
var map_center;

var reached_control_room = 0;
var dfs_position;
var dfs_counters;

var debugmode = 0;
var debug_buildtree = 0;    

// My little API
var get_position_char = function( map, rc ) {
    return map[rc.r].charAt(rc.c);
}
 
var add_rcs = function( rc, dir ) {
    return {r:(rc.r + dir.r), c:(rc.c + dir.c)};
}

var flat_rc = function( rc ) {
    return rc.c * R + rc.r;
}

var reconstruct_rc = function( value ) {
    return {r: (value % R), c: Math.floor( value / R )};
}


var movement_between_rcs = function( frc1, frc2 ) {
    var rc1 = reconstruct_rc( frc1 );
    var rc2 = reconstruct_rc( frc2 );
    var dx = rc2.c - rc1.c;
    var dy = rc2.r - rc1.r;
    
    if ( dx == 1 ) {
        return 'RIGHT';
    } else if ( dx == -1 ) {
        return 'LEFT';
    } else if ( dy == 1 ) {
        return 'DOWN';
    } else if ( dy == -1 ) {
        return 'UP';
    }
}

var get_neighbour = function( map, rc, dir, flags, retval, constraint )
{
    var modrc = add_rcs( rc, dir );
    var char = get_position_char( map, modrc);
    switch(char) {
        case "C":
            if ( constraint !== 'noc' ) {
                retval.push( flat_rc( modrc ) );
            }
            break;
        case ".":
        case "T":
            retval.push( flat_rc( modrc ) );
            break;
        case "?":
            flags.push('?');
            break;
        case "#":
            break;
    }
}

var get_neighbours = function( map, alist, aparents, rc, flags, constraint ) {
    var retval = [];
    var dirs = [{r:-1,c:0},{r:1,c:0},{r:0,c:1},{r:0,c:-1}];
    dirs.forEach( function( dir ) {
        flrc = flat_rc(add_rcs(rc, dir));
        if ( undefined === alist[flrc] 
             && ( undefined === aparents[flrc] || aparents[flrc] == flat_rc(rc) ) ) {
            get_neighbour( map, rc, dir, flags, retval, constraint );
        }
    } );
    return retval;
}

var build_tree_loop = function( map, this_round, visited, alist, aparents, constraint ) {
    var next_round = [];
    this_round.forEach( function( frc ) {
        if ( visited[frc] === undefined ) {
            visited[frc] = 1;
            var rc = reconstruct_rc(frc);
            if ( debug_buildtree ) {
                printErr('#visited [' + rc.r +',' + rc.c+']');
            }
            var mal = alist[ flat_rc( rc ) ];
            if ( undefined === mal) {
                var flags = [];
                var neighbours = get_neighbours( map, alist, aparents, rc, flags, constraint );
                if ( flags.length > 0 ) {
                    // if there is a question mark, abandoning building the tree
                } else {
                    next_round = next_round.concat( neighbours );
                    alist[ flat_rc( rc ) ] = neighbours;
                    neighbours.forEach( function ( frc ) {
                        if ( debug_buildtree ) {
                            var rrc = reconstruct_rc( frc );
                            printErr("#look at [" + rrc.r + ',' +rrc.c +']' );
                        }    
                        aparents[frc] = flat_rc( rc );
                    });
                }
            } else {
                mal.forEach( function ( frc ) {
                    next_round.push( frc );
                });
            }
        }
    } );
    return next_round;
} 

var build_tree = function( map, rootrc, alist, aparents, constraint ) {
    var visited = {};
    
    var next_round = [ flat_rc(rootrc) ];
    var this_round = [];
    
    var radius = 0;
    do {
        ++radius;
        this_round = next_round;
        next_round = build_tree_loop( map, this_round, visited, alist, aparents, constraint );
    } while ( next_round.length > 0 );
    
    return radius;
}

var child_path_to_parent = function( myparents, rcparent, rcchild ) {
    // reconstruct path
    var current = flat_rc(rcchild);
    var target  = flat_rc(rcparent);
    var path = [];
    while ( current !== target && current !== undefined ) {
        path.push( current );
        current = myparents[current];
    }
    path.push(current);
    return path;
}

var rounds_counter = 0;

var game_state = 0; // 0 at the beginning explore, 
                    // 5 looking for the control room
                    // 10 when going for control room
                    // 20 when control room is reached && escape

var get_next_dfs_target = function() {
    var targets = map_adjacency_lista[ dfs_position ];
    var dfs_counter = dfs_counters.pop();
    var target;
    if ( dfs_counter < targets.length ) {
        target = targets[dfs_counter];
        dfs_counter++;
        dfs_counters.push( dfs_counter );
        dfs_counters.push( 0 );
    } else {
        // leaving
        target = map_parentsa[ dfs_position ];
    }
    return target;
}

var is_next_dfs_target = function() {
    if ( undefined === dfs_counters ) {
        return true;
    }
    if ( dfs_counters.length > 1 ) {
        return true;
    }
    if ( dfs_counters.length <= 0 ) {
        return false;
    }
    var targets = map_adjacency_lista[ dfs_position ];
    if ( dfs_counters[0] < targets.length ) {
        return true;
    } else {
        return false;
    }
}

// game loop
while (true) {
    ++rounds_counter;
    
    var MAX_ROUNDS = 1200;
    // jetpack is for 1200 rounds
    // after the explore, we need ( 2 x radius ) rounds to reach
    // the control room, and (2 x radius) rounds to reach the exit
    
    var inputs = readline().split(' ');
    var KR = parseInt(inputs[0]); // row where Kirk is located.
    var KC = parseInt(inputs[1]); // column where Kirk is located.
    var krc = {r:KR, c:KC};
    var MAP = [];
    var startrc;
    var endrc;
    if ( debugmode ) {
       printErr( [R, C] );
       printErr( [KR, KC] );
    }
    for (var i = 0; i < R; i++) {
        var ROW = readline(); // C of the characters in '#.TC?' (i.e. one line of the ASCII maze).
        var start = ROW.indexOf('T');
        if ( start >= 0 ) {
            startrc = {r:i, c:start};
        }
        var end = ROW.indexOf('C');
        if ( end >= 0 ) {
            endrc = {r:i, c:end};
        }
        MAP.push( ROW );
        if ( debugmode ) {
           printErr( ROW );
        }
    }
    
    if ( undefined === map_center ) {
        map_center = startrc;
    }

    var before_game_state = game_state;
  
    if ( game_state < 5
         && rounds_counter >= MAX_ROUNDS - 4 * map_radius ) {
        map_constraint = "";
        game_state = 5;
    }
    
    if ( game_state < 5
         && !is_next_dfs_target()
         || game_state == 5
            && undefined !== endrc
            && undefined !== map_parentsa[flat_rc(endrc)] ) {
        map_adjacency_lista = {};
        map_parentsa = {};
        map_constraint = "";
        map_center = krc;
        game_state = 10;
    }
    
    if ( debugmode ) {
       printErr( game_state );
    }
    
    if ( undefined !== endrc 
         && KR == endrc.r
         && KC == endrc.c ) {
        if ( debugmode ) {
            printErr( 'Reached control room!' );
        }
        map_adjacency_lista = {};
        map_parentsa = {};
        map_constraint = "";
        map_center = startrc;
        game_state = 20;
    }


    // Write an action using print()
    // To debug: printErr('Debug messages...');
    if ( debug_buildtree ) {
       printErr('--->build_tree');
    }
    
    // radius is a pessimistic estimation
    map_radius = Math.max( map_radius, build_tree( MAP, map_center, map_adjacency_lista, map_parentsa, map_constraint) );
    
    if ( debugmode ) {
        var mal_keys = Object.keys( map_adjacency_lista );
        for ( var i = 0; i < mal_keys.length; i++ ) {
            var rci = reconstruct_rc(mal_keys[i]); 
            var strip = "";
            map_adjacency_lista[mal_keys[i]].forEach( function(frc) {
                var rrc = reconstruct_rc(frc);
                strip += '[' + rrc.r + ',' + rrc.c + '] ';
            });
            printErr( '   ===>[' + rci.r + ',' + rci.c + ']:' + strip );
        }
    }
    
    var movement = '';    
    switch( game_state ) {
        case 0:
        case 5:
            // DFS in the tree
            if ( undefined === dfs_position ) {
                dfs_position = flat_rc( startrc );
                dfs_counters = [0];
            }
            var target = get_next_dfs_target();
            movement = movement_between_rcs( dfs_position, target );
            dfs_position = target;
            break;
        case 10:
            path = child_path_to_parent( map_parentsa, krc, endrc );
            var target = path[ path.length - 2 ];
            movement = movement_between_rcs( flat_rc(krc), target );
            break;
        case 20:
            path = child_path_to_parent( map_parentsa, startrc, krc );
            var target = path[1];
            movement = movement_between_rcs( flat_rc(krc), target );
            break;
    }
    
    if ( debugmode ) {
       printErr('--->' + movement );
    }
    
    if ( !movement ) {
        print('anyad'); // Kirk's next move (UP DOWN LEFT or RIGHT).
    } else {
        print(movement);
    }
}
