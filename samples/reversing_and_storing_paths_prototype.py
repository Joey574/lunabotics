
# creates the library where paths are stored
paths = {}

# ROUTE: list of coordinates, the path itself
# DIRECTION: if the route is from dumping site to digging site or vice versa
# ID: paths number
# STATUS: whether the path is already validated, needs validation, or is invalid (due to obstruction, error...etc)
# ORIGIN: whether it is a recorded or a derived (reversed through function) route


# Enums - to limit the choice of options for these variables
from enum import Enum

class DIRECTION(Enum):
    A_TO_B = 1
    B_TO_A = 2

    @property
    def opposite(self):
        if self ==  DIRECTION.A_TO_B:
            return DIRECTION.B_TO_A
        if self == DIRECTION.B_TO_A:
            return DIRECTION.A_TO_B
        raise ValueError("INVALID DIRECTION")

class STATUS(Enum):
    VALID = 1
    UNVALIDATED = 2
    INVALID = 0

class ORIGIN(Enum):
    RECORDED = 1
    DERIVED = 2



# CLASS FOR PATH OBJECTS - what the reverse function will ingest
# ROUTE: list of coordinates, the path itself
# DIRECTION: if the route is from dumping site to digging site or vice versa
# ID: paths number
# STATUS: whether the path is already validated, needs validation, or is invalid (due to obstruction, error...etc)
# ORIGIN: whether it is a recorded or a derived (reversed through function) route
class Path:
    def __init__(self, route, direction, id, time, status, origin):
        self.route = route
        self.direction = direction
        self.id = id
        self.time = time
        self.status = status
        self.origin = origin



#REVERSING FUNCTION : expects a VALID, RECORDED path
def reversing(self): 
    #REVERSING ROUTE
    rev_route = []
    rev_route += self.route
    rev_route.reverse()

    #REVERSING DIRECTION
    rev_direction = self.direction.opposite

    #SETTING ID
    rev_id = self.id + "_rev"

    #CREATING REVERSED PATH OBJECT 
    # - TIME is set to None, because time has to be measured when the path is tested. 
    # - STATUS is always set as UNVALIDATED, because the path has to be tested to be marked as VALID.
    # - ORIGIN is always set as DERIVED, and SHOULD NOT be changed.
    p_rev = Path(rev_route, rev_direction, rev_id, None, STATUS.UNVALIDATED, ORIGIN.DERIVED) 
    paths.update({p_rev.id : p_rev})

    
if __name__ == "__main__":   # prevents the code from running when the file is imported   
    #SAMPLE OF WHAT WILL THE FUNCTION INGEST
    p_1 = Path([
    (0.0, 0.0),
    (0.7, 0.4),
    (1.2, 1.1),
    (1.9, 1.5),
    (2.5, 1.0),
    (3.1, 0.6),
    (3.8, 1.2),
    (4.2, 1.9),
    (4.9, 2.3),
    (5.5, 1.8)
    ], DIRECTION.A_TO_B, "p_1", 140.43, STATUS.VALID, ORIGIN.RECORDED)

    paths.update({p_1.id : p_1})

    #INVERSING THE "RECEIVED" PATH 
    reversing(p_1)

    #CHECKS that all key values are correct
    origpath = list(paths["p_1"].route)
    assert paths["p_1"].route == origpath
    assert paths["p_1_rev"].route == origpath[::-1]
    assert paths["p_1_rev"].direction != paths["p_1"].direction
    assert paths["p_1_rev"].status is STATUS.UNVALIDATED
    assert paths["p_1_rev"].origin is ORIGIN.DERIVED

    #TEST
    print(paths)
    print(paths["p_1"].route)
    print(paths["p_1"].direction)
    print(paths["p_1"].id)
    print(paths["p_1"].time)
    print(paths["p_1"].status)
    print(paths["p_1"].origin)
    print("NOW THE REVERSED PATH:")
    print(paths["p_1_rev"].route)
    print(paths["p_1_rev"].direction)
    print(paths["p_1_rev"].id)
    print(paths["p_1_rev"].time) #returns None, as time has to be measured while this path is tested
    print(paths["p_1_rev"].status)
    print(paths["p_1_rev"].origin)






