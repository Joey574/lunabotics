package app

import (
	"fyne.io/fyne/v2"
	"fyne.io/fyne/v2/app"
)

type App struct {
	Fyne fyne.App

	windows   map[string]Window
	factories map[string]WindowFactory
}

func New() *App {
	return &App{
		Fyne:      app.NewWithID("lunabotics"),
		windows:   make(map[string]Window),
		factories: make(map[string]WindowFactory),
	}
}

func (a *App) Register(id string, factory WindowFactory) {
	a.factories[id] = factory
}

func (a *App) OpenOrFocus(id string) Window {
	if w, ok := a.windows[id]; ok {
		w.Window().RequestFocus()
		return w
	}

	factory, ok := a.factories[id]
	if !ok {
		panic("no factory registered for id " + id)
	}

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

func (a *App) Run() error {
	a.Fyne.Run()
	return nil
}
