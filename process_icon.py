from PIL import Image
import os

input_path = r'C:\Users\Alfredo\.gemini\antigravity\brain\e3f99dba-afee-4352-ab76-a1f31ef17cdb\media__1778175064433.png'
output_path = r'c:\Users\Alfredo\Desktop\TFG\tfg_taller\android\app\src\main\res\drawable\ic_notificacion.png'

if not os.path.exists(input_path):
    print(f"Error: No se encuentra la imagen en {input_path}")
    exit(1)

img = Image.open(input_path).convert("RGBA")
datas = img.getdata()

newData = []
for item in datas:
    # Detectar el fondo oscuro (negro o casi negro)
    # El logo es blanco, así que el contraste es alto.
    if item[0] < 60 and item[1] < 60 and item[2] < 60:
        newData.append((0, 0, 0, 0)) # Transparente
    else:
        # Asegurar que el resto sea blanco puro para la silueta de Android
        newData.append((255, 255, 255, 255))

img.putdata(newData)
# Redimensionar a 96x96 (tamaño xhdpi para drawable genérico)
img = img.resize((96, 96), Image.Resampling.LANCZOS)

# Crear directorio si no existe (aunque debería existir)
os.makedirs(os.path.dirname(output_path), exist_ok=True)

img.save(output_path, "PNG")
print(f"Imagen procesada y guardada en {output_path}")
