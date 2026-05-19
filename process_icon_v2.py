from PIL import Image
import os

input_path = r'C:\Users\Alfredo\.gemini\antigravity\brain\80fa488b-f788-4d6c-a772-ae7e36073146\media__1778172861227.png'
output_path = r'c:\Users\Alfredo\Desktop\TFG\tfg_taller\android\app\src\main\res\drawable\ic_notificacion.png'

if not os.path.exists(input_path):
    # Intentar con el nombre anterior si el ID cambió o algo
    print("Error: No se encuentra la imagen.")
    exit(1)

img = Image.open(input_path).convert("RGBA")
width, height = img.size
datas = img.getdata()

# 1. Encontrar los límites del cuadrado negro central
# El cuadrado negro tiene valores bajos de RGB.
left, top, right, bottom = width, height, 0, 0
for y in range(height):
    for x in range(width):
        r, g, b, a = img.getpixel((x, y))
        if r < 100 and g < 100 and b < 100:
            if x < left: left = x
            if x > right: right = x
            if y < top: top = y
            if y > bottom: bottom = y

# 2. Procesar la imagen: 
# - Fuera del cuadrado negro -> Transparente
# - Dentro del cuadrado negro: si es oscuro -> Transparente, si es claro (el logo) -> Blanco
newData = []
for y in range(height):
    for x in range(width):
        r, g, b, a = img.getpixel((x, y))
        
        # Si está fuera del cuadrado negro detectado, hacerlo transparente
        if x < left or x > right or y < top or y > bottom:
            newData.append((0, 0, 0, 0))
        else:
            # Dentro del cuadrado negro
            # Si el pixel es claro (el coche/llave), lo dejamos blanco
            if r > 180 and g > 180 and b > 180:
                newData.append((255, 255, 255, 255))
            else:
                # El fondo negro del cuadrado, hacerlo transparente
                newData.append((0, 0, 0, 0))

img.putdata(newData)

# 3. Recortar la imagen a los límites del logo para que no tenga márgenes vacíos innecesarios
# (opcional pero recomendado para iconos)
logo_left, logo_top, logo_right, logo_bottom = width, height, 0, 0
has_pixels = False
for y in range(height):
    for x in range(width):
        if img.getpixel((x, y))[3] > 0:
            if x < logo_left: logo_left = x
            if x > logo_right: logo_right = x
            if y < logo_top: logo_top = y
            if y > logo_bottom: logo_bottom = y
            has_pixels = True

if has_pixels:
    img = img.crop((logo_left, logo_top, logo_right + 1, logo_bottom + 1))

# 4. Redimensionar a 96x96 con un pequeño padding interno para que no toque los bordes
canvas = Image.new("RGBA", (128, 128), (0, 0, 0, 0))
img.thumbnail((96, 96), Image.Resampling.LANCZOS)
offset = ((128 - img.width) // 2, (128 - img.height) // 2)
canvas.paste(img, offset)

# Guardar
os.makedirs(os.path.dirname(output_path), exist_ok=True)
canvas.save(output_path, "PNG")
print(f"Icono procesado con éxito y guardado en {output_path}")
