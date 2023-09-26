import math

class Entity:
    def __init__(self, json_data, is_name_only=False):
        # state data
        self.selected = False

        # persistent data
        if is_name_only:
            self.name = json_data
            self.coordinates = [0,0]
            self.num_entities = 0
        else:
            self.name = json_data['name']
            self.x, self.y = json_data['coordinates']
            self.num_entities = json_data['num_entities']

    def is_name(self, name):
        return self.name == name

    def is_in(self, x, y):
        return self.x <= x <= self.x + 100 and self.y <= y <= self.y + 50
    
    def move_to(self, x, y):
        self.x, self.y = x - 50, y - 25

    def draw(self, canvas):
        self.draw_entity(canvas)

    def draw_entity(self, canvas):
        num_entities = self.num_entities

        fill_color = "lightblue" if self.selected else "white"
        canvas.create_rectangle(self.x, self.y, self.x + 100, self.y + 50, outline='black', fill=fill_color, width=2)
        canvas.create_text(self.x + 50, self.y + 25, text=self.name, font=("Helvetica", 12))
        if num_entities:
            canvas.create_text(self.x + 70, self.y + 45, text=f"({num_entities} entities)", font=("Helvetica", 7))

class Relation:
    def __init__(self, json_data, get_entity_by_name):
        # state data
        self.selected = False

        # persistent data
        self.name = json_data['name']
        self.x, self.y = json_data['coordinates']
        self.entity_sets = [get_entity_by_name(name) for name in  json_data['entity_sets']]  # noqa: E501
        self.is_many = json_data['is_many']
        self.full_participation = json_data['full_participation']
        self.determines = json_data['determines']

    def is_in(self, x, y):
        return (self.x-50 <= x <= self.x+50 and self.y-25<=y<=self.y+25)
    
    def move_to(self, x, y):
        self.x, self.y = x,y

    def draw(self, canvas):
        self.draw_relationship(canvas)

    def draw_relationship(self, canvas):
        self.draw_lines(canvas)

        fill_color = "lightblue" if self.selected else "white"
        x,y = self.x, self.y

        # Define the vertices of the diamond
        diamond_points = [
            (x-50, y),  # Top point
            (x, y-25),  # Right point
            (x + 50, y),  # Bottom point
            (x, y + 25),  # Left point
        ]

        # Draw the diamond using lines
        canvas.create_polygon(diamond_points, outline='black', fill=fill_color, width=2)

        # Draw the name in the center of the diamond
        canvas.create_text(x, y, text=self.name, font=("Helvetica", 12))
    
    def draw_lines(self, canvas):
        for i in range(len(self.entity_sets)):
            x1, y1 = self.entity_sets[i].x, self.entity_sets[i].y
            direction_x = x1 - self.x 
            direction_y = y1 - self.y

            # Normalize the direction vector
            length = math.sqrt(direction_x ** 2 + direction_y ** 2)
            if length > 0:
                direction_x /= length
                direction_y /= length

            # Calculate the new position for 'n'/'1'
            n_x = self.x + 60 * direction_x
            n_y = self.y + 60 * direction_y

            # Draw two lines offset by 5 pixels if full_participation is True
            if self.full_participation[i]:
                offset_x = 2 * direction_y
                offset_y = -2 * direction_x
                canvas.create_line(x1 + 50 + offset_x, y1 + 25 + offset_y, self.x + offset_x, self.y + offset_y, fill='black')  # noqa: E501
                canvas.create_line(x1 + 50 - offset_x, y1 + 25 - offset_y, self.x - offset_x, self.y - offset_y, fill='black')  # noqa: E501
            else:
                canvas.create_line(x1 + 50, y1 + 25, self.x, self.y, fill='black')  # noqa: E501
            # Draw 'n'/'1' at the new position
            if self.is_many[i]:
                vars = ['n', 'm', 'l']
                cardinality = vars[i%3]
            else:
                cardinality = '1'
            canvas.create_text(n_x, n_y, text=cardinality, font=("Helvetica", 12))


class Inheritance:
    def __init__(self, json_data, get_entity_by_name):
        # state data
        self.selected = False

        # persistent data
        self.name = json_data['type']
        self.x, self.y = json_data['coordinates']
        self.entity_sets = [get_entity_by_name(name) for name in  json_data['entity_sets']]  # noqa: E501
        self.inherit_from = json_data['inherit_from']
        self.full_participation = json_data['full_participation']

    def is_in(self, x, y):
        return (self.x-50 <= x <= self.x+50 and self.y-25<=y<=self.y+25)
    
    def move_to(self, x, y):
        self.x, self.y = x,y

    def draw(self, canvas):
        self.draw_inheritance(canvas)

    def draw_inheritance(self, canvas):
        self.draw_lines(canvas)

        fill_color = "lightblue" if self.selected else "white"
        x,y = self.x, self.y

        # Draw the circle using lines
        canvas.create_oval(x-15,y-15,x+15,y+15, outline='black', fill=fill_color, width=2)

        # Draw the name in the center of the diamond
        canvas.create_text(x, y, text=self.name, font=("Helvetica", 12))
    
    def draw_lines(self, canvas):
        for i in range(len(self.entity_sets)):
            x1, y1 = self.entity_sets[i].x, self.entity_sets[i].y
            direction_x = x1+50 - self.x 
            direction_y = y1+25 - self.y

            # Normalize the direction vector
            length = math.sqrt(direction_x ** 2 + direction_y ** 2)
            if length > 0:
                direction_x /= length
                direction_y /= length

            # Calculate the new position for 'U'
            n_x = self.x + length/2 * direction_x
            n_y = self.y + length/2 * direction_y

            # Draw two lines offset by 5 pixels if full_participation is True
            if self.full_participation[i]:
                offset_x = 2 * direction_y
                offset_y = -2 * direction_x
                canvas.create_line(x1 + 50 + offset_x, y1 + 25 + offset_y, self.x + offset_x, self.y + offset_y, fill='black')  # noqa: E501
                canvas.create_line(x1 + 50 - offset_x, y1 + 25 - offset_y, self.x - offset_x, self.y - offset_y, fill='black')  # noqa: E501
            else:
                canvas.create_line(x1 + 50, y1 + 25, self.x, self.y, fill='black')  # noqa: E501
            # Draw 'U' at the new position
            if self.inherit_from[i]:
                canvas.create_text(n_x, n_y, text='U', font=("Helvetica", 12))
