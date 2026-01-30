#!/usr/bin/env python3
"""
Generate a TipCalculator app icon as a PNG file.
Uses Pillow for image generation.
"""

try:
    from PIL import Image, ImageDraw, ImageFont
except ImportError:
    print("Installing Pillow...")
    import subprocess
    subprocess.check_call(['pip3', 'install', 'Pillow'])
    from PIL import Image, ImageDraw, ImageFont

import math

def create_app_icon(size=1024):
    # Create image with dark background
    img = Image.new('RGBA', (size, size), (26, 26, 26, 255))
    draw = ImageDraw.Draw(img)
    
    # Colors
    dark_bg = (26, 26, 26)
    darker_bg = (13, 13, 13)
    green_light = (74, 222, 128)  # #4ade80
    green_dark = (34, 197, 94)    # #22c55e
    white = (255, 255, 255)
    light_gray = (229, 229, 229)
    
    # Create gradient background
    for y in range(size):
        r = int(dark_bg[0] + (darker_bg[0] - dark_bg[0]) * y / size)
        g = int(dark_bg[1] + (darker_bg[1] - dark_bg[1]) * y / size)
        b = int(dark_bg[2] + (darker_bg[2] - dark_bg[2]) * y / size)
        draw.line([(0, y), (size, y)], fill=(r, g, b))
    
    # Center coordinates
    cx, cy = size // 2, size // 2
    
    # Scale factor
    s = size / 1024
    
    # Draw receipt shape (white rounded rectangle)
    receipt_width = int(360 * s)
    receipt_height = int(520 * s)
    receipt_x1 = cx - receipt_width // 2
    receipt_y1 = cy - int(280 * s)
    receipt_x2 = receipt_x1 + receipt_width
    receipt_y2 = receipt_y1 + receipt_height
    radius = int(32 * s)
    
    # Draw rounded rectangle for receipt
    draw.rounded_rectangle(
        [receipt_x1, receipt_y1, receipt_x2, receipt_y2],
        radius=radius,
        fill=(255, 255, 255, 242)
    )
    
    # Draw tear pattern at bottom
    tear_y = receipt_y2 - int(40 * s)
    tear_points = []
    num_tears = 9
    tear_width = receipt_width / num_tears
    for i in range(num_tears + 1):
        x = receipt_x1 + i * tear_width
        y = tear_y if i % 2 == 0 else tear_y - int(20 * s)
        tear_points.append((x, y))
    tear_points.append((receipt_x2, receipt_y2))
    tear_points.append((receipt_x1, receipt_y2))
    draw.polygon(tear_points, fill=(255, 255, 255, 242))
    
    # Draw green circle for dollar sign
    circle_radius = int(100 * s)
    circle_cy = cy - int(100 * s)
    
    # Create gradient circle
    for r in range(circle_radius, 0, -1):
        ratio = r / circle_radius
        color_r = int(green_light[0] * ratio + green_dark[0] * (1 - ratio))
        color_g = int(green_light[1] * ratio + green_dark[1] * (1 - ratio))
        color_b = int(green_light[2] * ratio + green_dark[2] * (1 - ratio))
        draw.ellipse(
            [cx - r, circle_cy - r, cx + r, circle_cy + r],
            fill=(color_r, color_g, color_b)
        )
    
    # Draw dollar sign
    try:
        font_size = int(140 * s)
        font = ImageFont.truetype("/System/Library/Fonts/SFNSRounded.ttf", font_size)
    except:
        try:
            font = ImageFont.truetype("/System/Library/Fonts/Helvetica.ttc", font_size)
        except:
            font = ImageFont.load_default()
    
    dollar_text = "$"
    bbox = draw.textbbox((0, 0), dollar_text, font=font)
    text_width = bbox[2] - bbox[0]
    text_height = bbox[3] - bbox[1]
    draw.text(
        (cx - text_width // 2, circle_cy - text_height // 2 - int(15 * s)),
        dollar_text,
        fill=white,
        font=font
    )
    
    # Draw detail lines (receipt lines)
    line_x = cx - int(120 * s)
    line_height = int(16 * s)
    line_radius = int(8 * s)
    
    # Line 1
    draw.rounded_rectangle(
        [line_x, cy + int(40 * s), line_x + int(160 * s), cy + int(40 * s) + line_height],
        radius=line_radius,
        fill=light_gray
    )
    
    # Line 2
    draw.rounded_rectangle(
        [line_x, cy + int(80 * s), line_x + int(120 * s), cy + int(80 * s) + line_height],
        radius=line_radius,
        fill=light_gray
    )
    
    # Line 3
    draw.rounded_rectangle(
        [line_x, cy + int(120 * s), line_x + int(140 * s), cy + int(120 * s) + line_height],
        radius=line_radius,
        fill=light_gray
    )
    
    # Draw percentage badge
    badge_x = cx + int(60 * s)
    badge_y = cy + int(60 * s)
    badge_w = int(80 * s)
    badge_h = int(56 * s)
    
    # Green badge with gradient effect
    draw.rounded_rectangle(
        [badge_x, badge_y, badge_x + badge_w, badge_y + badge_h],
        radius=int(12 * s),
        fill=green_light
    )
    
    # Percent symbol
    try:
        percent_font_size = int(32 * s)
        percent_font = ImageFont.truetype("/System/Library/Fonts/SFNSRounded.ttf", percent_font_size)
    except:
        try:
            percent_font = ImageFont.truetype("/System/Library/Fonts/Helvetica.ttc", percent_font_size)
        except:
            percent_font = font
    
    percent_text = "%"
    bbox = draw.textbbox((0, 0), percent_text, font=percent_font)
    pw = bbox[2] - bbox[0]
    ph = bbox[3] - bbox[1]
    draw.text(
        (badge_x + badge_w // 2 - pw // 2, badge_y + badge_h // 2 - ph // 2 - int(3 * s)),
        percent_text,
        fill=white,
        font=percent_font
    )
    
    # Draw total line
    draw.rounded_rectangle(
        [line_x, cy + int(180 * s), line_x + int(240 * s), cy + int(180 * s) + int(24 * s)],
        radius=int(12 * s),
        fill=dark_bg
    )
    
    return img

if __name__ == "__main__":
    import os
    
    base_path = "/Users/danielguerithault/Documents/TipCalculator"
    icon_path = os.path.join(base_path, "TipCalculator/Assets.xcassets/AppIcon.appiconset")
    
    # Generate 1024x1024 icon
    print("Generating app icon...")
    icon = create_app_icon(1024)
    
    # Save the icon
    output_path = os.path.join(icon_path, "AppIcon.png")
    icon.save(output_path, "PNG")
    print(f"Saved: {output_path}")
    
    print("Done! Icon generated successfully.")
