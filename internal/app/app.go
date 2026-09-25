package app

import (
	"lunabotics/v2/internal/engine"

	"fyne.io/fyne/v2"
	"fyne.io/fyne/v2/app"
)

type App struct {
	Fyne   fyne.App
	Engine *engine.Engine

	windows   map[string]Window
	factories map[string]WindowFactory
}

func New() *App {
	return &App{
		Fyne:   app.NewWithID("lunabotics"),
		Engine: engine.New(),

		windows:   make(map[string]Window),
		factories: make(map[string]WindowFactory),
	}
}

// Register takes a window id as a string and its factory, this must be set before any other call
// that may take a window id
func (a *App) Register(id string, factory WindowFactory) {
	a.factories[id] = factory
}

// OpenOrFocus takes a window id as a string and will bring it to focus if it already exists
// or create it if does not
//
// OpenOrFocus overrides fyne.Window.OnClosed, as such windows needing to do something on close
// should use the app.Close interface
func (a *App) OpenOrFocus(id string) Window {

	// first check if window is already open
	if w, ok := a.windows[id]; ok {
		w.Window().RequestFocus()
		return w
	}

	// window isn't open, grab the factory
	factory, ok := a.factories[id]
	if !ok {
		panic("no factory registered for id " + id)
	}

	// create the window and store it
	w := factory(a)
	wn := w.Window()
	a.windows[id] = w
	wn.SetOnClosed(func() {
		delete(a.windows, id)
		w.Close()
	})

	wn.ShowAndRun()
	return w
}

// Run executes the program and begins graphical display
func (a *App) Run() error {
	a.Fyne.Run()
	return nil
}
