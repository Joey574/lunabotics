package app

import "fyne.io/fyne/v2"

type WindowFactory func(*App) Window

type Window interface {
	Window() fyne.Window
	Close() error
}
