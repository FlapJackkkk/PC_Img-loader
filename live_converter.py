# Everything here is just organized for the people who wanna edit it


import json
import time
import os
from PIL import Image


IMAGE_TO_WATCH = "input.jpg" 
JSON_OUTPUT = "/Users/YOURNAME/Downloads/executor Workspace/image_data.json"
SCREEN_SIZE = 39

def process_image():
    if not os.path.exists(IMAGE_TO_WATCH):
        return 

    try:
        
        img = Image.open(IMAGE_TO_WATCH).convert('RGB')
        img = img.resize((SCREEN_SIZE, SCREEN_SIZE))
        
        pixel_data = []
        for y in range(SCREEN_SIZE):
            row = []
            for x in range(SCREEN_SIZE):
                r, g, b = img.getpixel((x, y))
                
                row.append({
                    "r": round(r/255, 3),
                    "g": round(g/255, 3),
                    "b": round(b/255, 3)
                })
            pixel_data.append(row)

        
        with open(JSON_OUTPUT, "w") as f:
            json.dump(pixel_data, f)
            
        print(f"[{time.strftime('%H:%M:%S')}] ✔ Screen Updated!")
        
    except Exception as e:
        print(f"Whoops, Error: {e}")

print(f" Live Converter Active! Watching for {IMAGE_TO_WATCH}...")
print("To change the screen, just overwrite 'input.jpg' with a new image.")


while True:
    process_image()
    time.sleep(1) # i just dont wanna destroy my cpy lmaoo
