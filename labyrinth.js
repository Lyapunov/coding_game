
var inputs = readline().split(' ');
var R = parseInt(inputs[0]); // number of rows.
var C = parseInt(inputs[1]); // number of columns.
var A = parseInt(inputs[2]); // number of rounds between the time the alarm countdown is activated and the time the alarm goes off.

var map_adjacency_lista = {};
var map_parentsa = {};

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

var get_neighbour = function( map, rc, dir, flags, retval )
{
    var modrc = add_rcs( rc, dir );
    var char = get_position_char( map, modrc);
    switch(char) {
        case "C":
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

var get_neighbours = function( map, alist, aparents, rc, flags ) {
    var retval = [];
    var dirs = [{r:-1,c:0},{r:1,c:0},{r:0,c:1},{r:0,c:-1}];
    dirs.forEach( function( dir ) {
        flrc = flat_rc(add_rcs(rc, dir));
        if ( undefined === alist[flrc] 
             && ( undefined === aparents[flrc] || aparents[flrc] == flat_rc(rc) ) ) {
            get_neighbour( map, rc, dir, flags, retval );
        }
    } );
    return retval;
}

var build_tree_loop = function( map, this_round, visited, alist, aparents ) {
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
                var neighbours = get_neighbours( map, alist, aparents, rc, flags );
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

var build_tree = function( map, rootrc, alist, aparents, termin ) {
    var visited = {};
    
    var next_round = [ flat_rc(rootrc) ];
    var this_round = [];
    
    do {
        this_round = next_round;
        next_round = build_tree_loop( map, this_round, visited, alist, aparents );
        if ( undefined !== termin && undefined !== visited[flat_rc(termin)] ) {
            return;
        }
    } while ( next_round.length > 0 );
    
    return visited;
}

var child_path_to_parent = function( myparents, rcparent, rcchild ) {
    // reconstruct path
    var current = flat_rc(rcchild);
    var target  = flat_rc(rcparent);
    printErr( '...> ' + current + ' ' + target );
    var path = [];
    while ( current !== target && current !== undefined ) {
        path.push( current );
        current = myparents[current];
    }
    path.push(current);
    return path;
}

var shortest_path = function( map, rc1, rc2 ) {
    var mylist = {};
    var myparents = {};
    build_tree( map, rc1, mylist, myparents, rc2 );

    return child_path_to_parent( myparents, rc1, rc2 );
}

var counter = 0;

// game loop
while (true) {
    
/*    ++counter;
    if ( counter > 80 ) {
        debugmode = 1;
        debug_buildtree = 1;
    }
    if ( counter > 105 ) {
        print ('ajjaj');
    }*/
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

    var before_reached_control_room = reached_control_room;

    if ( undefined === endrc ) {
    } else {
        if ( KR == endrc.r && KC == endrc.c ) {
            if ( debugmode ) {
                printErr( 'Reached control room!' );
            }
            reached_control_room = 1;
        }
    }
    
    if ( !before_reached_control_room 
         && reached_control_room ) {
        map_adjacency_lista = {};
        map_parentsa = {};

    }

    // Write an action using print()
    // To debug: printErr('Debug messages...');
    if ( debug_buildtree ) {
       printErr('--->build_tree');
    }
    var now_visited = build_tree( MAP, startrc, map_adjacency_lista, map_parentsa);
    
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
    if (reached_control_room) {
        //var path = shortest_path( MAP, krc, startrc );
        //var target = path[ path.length - 1 ];
        path = child_path_to_parent( map_parentsa, startrc, krc );
        var target = path[1];
        printErr(path);
        movement = movement_between_rcs( flat_rc(krc), target );
    } else {
        if ( undefined === endrc || undefined === map_parentsa[flat_rc(endrc)]) {
            // DFS in the tree
            if ( undefined === dfs_position ) {
                dfs_position = flat_rc( startrc );
                dfs_counters = [0];
            }
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
            movement = movement_between_rcs( dfs_position, target );
            dfs_position = target;
        } else {
            //var path = shortest_path( MAP, krc, endrc );
            path = child_path_to_parent( map_parentsa, krc, endrc );
            printErr('#####>' + path);
            var target = path[ path.length - 2 ];
            movement = movement_between_rcs( flat_rc(krc), target );
        }
    }
    
    if ( debugmode ) {
       printErr('--->' + movement );
    }
    
    if ( !movement ) {
        print('ajjaj'); // Kirk's next move (UP DOWN LEFT or RIGHT).
    } else {
        print(movement);
    }
}
