import tkinter as tk
from tkinter import filedialog
from canvas import DiagramApp
from loader import load_json

filepath = 'er_data.json'

def main():
    filepath = filedialog.askopenfilename(defaultextension='.json')
    entities, relations, inherits = load_json(filepath)

    root = tk.Tk()
    root.title("ER Diagram")

    app = DiagramApp(root, entities, relations, inherits)

    # root.bind('a', app.on_key_a_press)  # add new entity_set to diagram
    # root.bind('s', app.on_key_s_press)  # add new relationship to diagram
    root.bind('<Control-Key-s>', app.on_canvas_save)

    root.mainloop()

if __name__ == "__main__":
    main()
