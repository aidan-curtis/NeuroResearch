from __future__ import print_function
from PIL import Image
from PIL import ImageDraw

im = Image.open("LBI.png")
print(im.format, im.size, im.mode)

draw = ImageDraw.Draw(im)
draw.line((0, im.size[1], im.size[0], 0), fill=(0,0,255,255))
del draw


im.show()
