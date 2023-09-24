from tkinter import filedialog
from loader import save_json
from object import Entity
from object import Relation
import tkinter as tk


class DiagramApp:
    def __init__(self, root, entities, relationships, inherits):
        self.root = root
        self.entities = entities
        self.relationships = relationships
        self.inherits = inherits
        self.selected_entity = None
        self.selected_relationship = None
        self.selected_inherit=None

        self.canvas = tk.Canvas(root, width=1600, height=1200)
        self.canvas.pack()
        self.canvas.bind("<ButtonPress-1>", self.on_canvas_click)
        self.canvas.bind("<B1-Motion>", self.on_canvas_drag)
        self.canvas.bind("<ButtonRelease-1>", self.on_canvas_release)

        self.draw()

    def draw(self):
        for relationship in self.relationships:
            relationship.draw(self.canvas)
        for inherit in self.inherits:
            inherit.draw(self.canvas)
        for entity in self.entities:
            entity.draw(self.canvas)

    def on_canvas_click(self, event):
        x, y = event.x, event.y
        for entity in self.entities:
            if entity.is_in(x, y):
                entity.selected = True
                self.selected_entity = entity
            else:
                entity.selected = False
        for relationship in self.relationships:
            if relationship.is_in(x, y):
                relationship.selected = True
                self.selected_relationship = relationship
            else:
                relationship.selected = False
        for inherit in self.inherits:
            if inherit.is_in(x, y):
                inherit.selected = True
                self.selected_inherit = inherit
            else:
                inherit.selected = False
        self.canvas.delete("all")
        self.draw()

    def on_canvas_drag(self, event):
        if self.selected_entity:
            x, y = event.x, event.y
            self.selected_entity.move_to(x, y)
            self.canvas.delete("all")
            self.draw()
        elif self.selected_relationship:
            x, y = event.x, event.y
            self.selected_relationship.move_to(x, y)
            self.canvas.delete("all")
            self.draw()
        elif self.selected_inherit:
            x, y = event.x, event.y
            self.selected_inherit.move_to(x, y)
            self.canvas.delete("all")
            self.draw()

    def on_canvas_release(self, event):
        self.selected_entity = None
        self.selected_relationship = None
        self.selected_inherit = None

    def on_canvas_save(self, event):
        file_path = filedialog.asksaveasfilename(defaultextension=".json", filetypes=[("JSON files", "*.json")])
        # Check if a filename was selected
        if file_path:
            save_json(file_path, self.entities, self.relationships, self.inherits)

    def on_key_a_press(self, event):
        if event.char == "a":
            self.create_entity_set()

    def on_key_s_press(self, event):
        if event.char == "s":
            self.create_relationship()

    def create_entity_set(self):
        # Create a custom dialog window
        dialog = tk.Toplevel(self.root)
        dialog.title("Create New Entity Set")

        # Label and entry for "name"
        name_label = tk.Label(dialog, text="Name:")
        name_label.pack()
        name_entry = tk.Entry(dialog)
        name_entry.pack()

        # Label and entry for "num_entities"
        num_entities_label = tk.Label(dialog, text="Number of Entities:")
        num_entities_label.pack()
        num_entities_entry = tk.Entry(dialog)
        num_entities_entry.pack()

        # Buttons
        cancel_button = tk.Button(dialog, text="Cancel", command=dialog.destroy)
        cancel_button.pack(side="left")
        add_button = tk.Button(
            dialog,
            text="Add",
            command=lambda: self.add_entity(
                dialog, name_entry.get(), num_entities_entry.get()
            ),
        )
        add_button.pack(side="left")

    def add_entity(self, dialog, name, num_entities):
        try:
            num_entities = int(num_entities)
            if name and num_entities >= 0:
                new_entity = Entity(
                    {"name": name, "coordinates": [0, 0], "num_entities": num_entities}
                )
                self.entities.append(new_entity)
                self.draw()
                dialog.destroy()
        except ValueError:
            pass

    def create_relationship(self):
        # Create a custom dialog window for creating a relationship
        dialog = tk.Toplevel(self.root)
        dialog.title("Create New Relationship")

        # Label and entry for "name"
        name_label = tk.Label(dialog, text="Name:")
        name_label.pack()
        name_entry = tk.Entry(dialog)
        name_entry.pack()

        # Label and buttons for adding/removing entity set rows
        entity_sets_label = tk.Label(dialog, text="Entity Sets:")
        entity_sets_label.pack()

        add_row_button = tk.Button(
            dialog, text="Add Entity Set", command=lambda: self.add_entity_set(dialog)
        )
        add_row_button.pack()

        # Container for entity set input rows
        self.entity_set_entries = []

        # Initial entity set rows (default to 2 rows)
        for _ in range(2):
            self.add_entity_set(dialog)

        # OK button to finalize the relationship
        ok_button = tk.Button(
            dialog,
            text="OK",
            command=lambda: self.add_relationship(dialog, name_entry.get()),
        )
        ok_button.pack()

    def add_entity_set(self, dialog):
        entity_set_frame = tk.Frame(dialog)
        entity_set_frame.pack()

        entity_set_name_label = tk.Label(entity_set_frame, text="Entity Set Name:")
        entity_set_name_label.pack(side="left")
        entity_set_name_entry = tk.Entry(entity_set_frame)
        entity_set_name_entry.pack(side="left")

        is_many_var = tk.BooleanVar()
        is_many_checkbox = tk.Checkbutton(
            entity_set_frame, text="Is Many", variable=is_many_var
        )
        is_many_checkbox.pack(side="left")

        full_participation_var = tk.BooleanVar()
        full_participation_checkbox = tk.Checkbutton(
            entity_set_frame, text="Full Participation", variable=full_participation_var
        )
        full_participation_checkbox.pack(side="left")

        determines_var = tk.BooleanVar()
        determines_checkbox = tk.Checkbutton(
            entity_set_frame, text="Determines", variable=determines_var
        )
        determines_checkbox.pack(side="left")

        self.entity_set_entries.append(
            {
                "name": entity_set_name_entry,
                "is_many": is_many_var,
                "full_participation": full_participation_var,
                "determines": determines_var,
            }
        )

    def add_relationship(self, dialog, name):
        entity_sets = []
        is_many = []
        full_participation = []
        determines = []

        for entry in self.entity_set_entries:
            entity_sets.append(entry["name"].get())
            is_many.append(entry["is_many"].get())
            full_participation.append(entry["full_participation"].get())
            determines.append(entry["determines"].get())

        # Create a new Relationship object and add it to the list
        def get_entity_by_name(name):
            for entity in self.entities:
                if entity.is_name(name):
                    return entity
            return Entity(name, True)
    
        new_relationship = Relation(
            {
                "name": name,
                "coordinates": [0, 0],
                "entity_sets": entity_sets,
                "is_many": is_many,
                "full_participation": full_participation,
                "determines": determines,
            },
            get_entity_by_name
        )
        self.relationships.append(new_relationship)
        self.draw()
        dialog.destroy()
