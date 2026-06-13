import os
from PIL import Image, ImageDraw

def process_icon():
    icon_path = os.path.join("assets", "icon", "app_icon.png")
    if not os.path.exists(icon_path):
        print(f"Error: {icon_path} not found.")
        return

    img = Image.open(icon_path).convert("RGBA")
    width, height = img.size

    # Get the background color from the top-left pixel
    bg_color = img.getpixel((0, 0))
    print(f"Detected Background Color: RGBA{bg_color}")
    
    # Convert RGBA background to Hex color (RGB only)
    hex_bg = f"#{bg_color[0]:02X}{bg_color[1]:02X}{bg_color[2]:02X}"
    print(f"HEX Background Color: {hex_bg}")

    # Make background completely transparent
    tolerance = 30
    pixels = img.load()
    for y in range(height):
        for x in range(width):
            r, g, b, a = pixels[x, y]
            dist = ((r - bg_color[0])**2 + (g - bg_color[1])**2 + (b - bg_color[2])**2)**0.5
            if dist <= tolerance:
                pixels[x, y] = (0, 0, 0, 0)
    
    # Now get the bounding box of the non-transparent pixels
    bbox = img.getbbox()
    if not bbox:
        print("Error: Could not find any line art (all pixels match background).")
        return
    
    min_x, min_y, max_x, max_y = bbox
    art_w = max_x - min_x
    art_h = max_y - min_y
    print(f"Line art bounding box: x={min_x}..{max_x}, y={min_y}..{max_y} (size {art_w}x{art_h})")
    
    art_img = img.crop(bbox)

    # Resize the line art so it fits nicely in the safe zone of 512x512 canvas
    # The safe circle diameter is 338 pixels (66% of 512)
    # Let's scale it so the max dimension is 280 pixels, leaving plenty of safe space
    max_dim = 280
    scale = min(max_dim / float(art_w), max_dim / float(art_h))
    new_w = int(art_w * scale)
    new_h = int(art_h * scale)
    
    resized_art = art_img.resize((new_w, new_h), Image.Resampling.LANCZOS)
    print(f"Resized line art to {new_w}x{new_h}")

    # Create the transparent 512x512 foreground canvas and paste the resized line art in the center
    fg_img = Image.new("RGBA", (512, 512), (0, 0, 0, 0))
    paste_x = (512 - new_w) // 2
    paste_y = (512 - new_h) // 2
    fg_img.paste(resized_art, (paste_x, paste_y), resized_art)

    # Save the foreground image
    fg_path = os.path.join("assets", "icon", "app_icon_foreground.png")
    fg_img.save(fg_path, "PNG")
    print(f"Saved transparent foreground icon to {fg_path}")

def process_legacy_icon():
    icon_path = os.path.join("assets", "icon", "app_icon.png")
    if not os.path.exists(icon_path):
        print(f"Error: {icon_path} not found.")
        return

    img = Image.open(icon_path).convert("RGBA")
    width, height = img.size

    # Create a rounded rectangle mask for legacy icons to avoid sharp corners
    # A radius of 80px (15.6% of 512px) creates a beautiful squircle/rounded icon
    mask = Image.new("L", (width, height), 0)
    draw = ImageDraw.Draw(mask)
    draw.rounded_rectangle((0, 0, width - 1, height - 1), radius=80, fill=255)

    img.putalpha(mask)

    legacy_path = os.path.join("assets", "icon", "app_icon_legacy.png")
    img.save(legacy_path, "PNG")
    print(f"Saved legacy rounded icon to {legacy_path}")

if __name__ == "__main__":
    process_icon()
    process_legacy_icon()
