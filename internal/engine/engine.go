package engine

import "context"

type Engine struct{}

func New() *Engine {
	return &Engine{}
}

// ReadContext takes a context which can be cancelled, forcing an early exit and a read request
// ReadContext will iterate through known systems on the network in an attempt to retrieve the requested data
// It is intended that the rover itself will be at the bottom of this stack, allowing instances to pull
// information from other instances before using costly bandwidth
//
// ReadContext can return an error if the information is not found or a connection can't be made
func (e *Engine) ReadContext(ctx context.Context, req *ReadRequest) (*ReadResponse, error)

// WriteContext takes a context which can be cancelled, forcing an early exit and a write request
// WriteContext writes directly to the rover, as this function is meant to send information which will change
// the state of the rover
//
// WriteContext can return an error if the connection can't be made or the rover denies the request
func (e *Engine) WriteContext(ctx context.Context, req *WriteRequest) (*WriteResponse, error)
