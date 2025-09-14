from picographics import PicoGraphics, DISPLAY_UNICORN_PACK, PEN_P8
from picounicorn import PicoUnicorn
import time

TEXT = "Rate And Review"

# By default P8 has a greyscale palette
graphics = PicoGraphics(DISPLAY_UNICORN_PACK, pen_type=PEN_P8)
graphics.set_font
picounicorn = PicoUnicorn()

t = picounicorn.get_width()

wrap = -graphics.measure_text(TEXT, scale=1)

while True:
    graphics.set_pen(0)
    graphics.clear()
    graphics.set_pen(75)
    graphics.text(TEXT, t, 0, scale=1, spacing=1, fixed_width=False)
    picounicorn.update(graphics)
    t -= 1
    time.sleep(0.1)
    if t <= wrap:
        t = picounicorn.get_width()
