This file contains an extremely rough algorithm comparison
The included Python file will generate a weighted graph representing a grid, with the option to include obstacle nodes

Algorithm 1: Dijkstra's Algorithm
-Initialize distance to all nodes as infinite, except the start node
-Add start node to queue
-For each node in queue: Check if each adjacent node can be reached more quickly from current node than an earlier path, if so update distance to that node and add it to the queue.
-Returns: Distance to all nodes from the start node.

Algorithm 2: Optimistic Algorithm
-From initial node, find best travel direction to end node.
-If best travel direction leads to obstacle, rotate right, unless that would take you off the grid, then rotate left.
-Step along best travel direction, repeat until you reach the destination.
-Returns: Path list of nodes in order from current position to destination.

As tested the optimistic algorithm runs in around 3/4 the time of Dijkstra's on grid sizes up to 150x150