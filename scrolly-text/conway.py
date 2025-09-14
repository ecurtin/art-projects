# Conway's Game of Life
# Converted by Michael Horne from Steve Baines' Pico Unicorn pack example (Thanks to Tony Goodhew for spotting!)
# https://forums.pimoroni.com/t/pico-unicorn-pack-not-working-in-micropython/15997/5
# 14 Feb 2021 - Pimoroni UF2 0.0.7

from picounicorn import PicoUnicorn
from picographics import PicoGraphics, DISPLAY_UNICORN_PACK, PEN_P8

import random
import time

picounicorn = PicoUnicorn()
graphics = PicoGraphics(DISPLAY_UNICORN_PACK, pen_type=PEN_P8)

w = picounicorn.get_width()
h = picounicorn.get_height()
print("Width ", w)
print("Height ", h)

class Cells:
    def __init__(self):
        self.cells = [[0]*h for i in range(w)]

    def clear_all(self):
        for x in range(w):
            for y in range(h):
                self.cells[x][y] = 0

    def set_random_cells_to_value(self, prob, value):
        for x in range(w):
            for y in range(h):
                if random.random() < prob:
                    self.cells[x][y] = value

    def is_alive(self,x,y):
        x = x % w
        y = y % h
        return self.cells[x][y] == 255

    def get_num_live_neighbours(self, x, y):
        num = 0
        num += (1 if self.is_alive(x-1,y-1) else 0)
        num += (1 if self.is_alive(x  ,y-1) else 0)
        num += (1 if self.is_alive(x+1,y-1) else 0)
        num += (1 if self.is_alive(x-1,y) else 0)
        num += (1 if self.is_alive(x+1,y) else 0)
        num += (1 if self.is_alive(x-1,y+1) else 0)
        num += (1 if self.is_alive(x  ,y+1) else 0)
        num += (1 if self.is_alive(x+1,y+1) else 0)
        return num
        
    def iterate_from(self, fromCells):
        for x in range(w):
            for y in range(h):
                num_live_nbrs = fromCells.get_num_live_neighbours(x,y)
                is_alive = fromCells.is_alive(x,y)
                if is_alive and (num_live_nbrs < 2 or num_live_nbrs > 3):
                    self.cells[x][y] = 0 # Died
                elif not is_alive and num_live_nbrs == 3:
                    self.cells[x][y] = 255 # Born
                else:
                    self.cells[x][y] = fromCells.cells[x][y] # Unchanged state

def ExportToLeds(cells):
    for x in range(w):
        for y in range(h):
            value = cells[x][y]
            picounicorn.set_pixel(x,y,value, value, value)
    picounicorn.update(graphics)


cellsA = Cells()
cellsB = Cells()
start = True

while True:
    if start:
        print("Clearing all cells")
        cellsA.clear_all()
        cellsA.set_random_cells_to_value(0.2, 255)
        start = False

    ExportToLeds(cellsA.cells)
    time.sleep_ms(200)
    cellsB.iterate_from(cellsA)
    (cellsA, cellsB) = (cellsB, cellsA)
    start = picounicorn.is_pressed(picounicorn.BUTTON_A)
