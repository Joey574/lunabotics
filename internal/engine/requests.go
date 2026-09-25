package engine

type RequestType int

// RequestType
// as of 9/24/26 these are entirely made up as placeholders
// these must be verified with the robot team, DO NOT depend
// on the values of these staying the same
const (
	Move RequestType = iota
	Turn
	Scoop
)

type ReadRequest struct{}
type ReadResponse struct{}

type WriteRequest struct{}
type WriteResponse struct{}
