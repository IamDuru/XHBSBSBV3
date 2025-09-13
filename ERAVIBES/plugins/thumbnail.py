import aiofiles, aiohttp, base64, os, random, re, textwrap
from urllib.parse import urlparse
from io import BytesIO

from PIL import Image, ImageDraw, ImageFont, ImageFilter, ImageEnhance, ImageOps

from .. import bot
from ..console import logs

START_IMAGE_URL = "ERAVIBES/resource/thumbnail.png"


async def download_thumbnail(vidid: str):
    async with aiohttp.ClientSession() as session:
        urls = [
            f"https://i.ytimg.com/vi/{vidid}/maxresdefault.jpg",
            f"https://i.ytimg.com/vi/{vidid}/sddefault.jpg",
            f"https://i.ytimg.com/vi/{vidid}/hqdefault.jpg",
            START_IMAGE_URL,
        ]
        
        thumbnail = f"cache/temp_{vidid}.png"
        
        for url in urls:
            async with session.get(url) as resp:
                if resp.status == 200:
                    async with aiofiles.open(thumbnail, "wb") as f:
                        await f.write(await resp.read())
                    return thumbnail

async def get_user_logo(user_id):
    try:
        user_chat = await bot.get_chat(user_id)
        user_image = user_chat.photo.big_file_id
    except:
        user_chat = await bot.get_me()
        user_image = user_chat.photo.big_file_id
    
    filename = f"cache/{user_id if 'except' not in locals() else bot.id}.png"
    return await bot.download_media(user_image, filename)

def changeImageSize(max_width, max_height, image):
    width_ratio = max_width / image.width
    height_ratio = max_height / image.height
    new_width = int(width_ratio * image.width)
    new_height = int(height_ratio * image.height)
    return image.resize((new_width, new_height))

def circle_image(image, size):
    mask = Image.new("L", (size, size), 0)
    ImageDraw.Draw(mask).ellipse((0, 0, size, size), fill=255)
    output = ImageOps.fit(image, mask.size, centering=(0.5, 0.5))
    output.putalpha(mask)
    return output

def random_color_generator():
    return tuple(random.randint(0, 255) for _ in range(3))


async def create_thumbnail(results, user_id):
    if not results:
        return START_IMAGE_URL
    title = results.get("title")
    title = re.sub("\W+", " ", title)
    title = title.title()
    vidid = results.get("id")
    duration = results.get("duration")
    views = results.get("views")
    channel = results.get("channel")
    image = await download_thumbnail(vidid)
    logo = await get_user_logo(user_id)
    image_string = "image string here"
    font_string_01 = "font 01 sring here"
    font_string_02 = "font 02 sring here"
    base_image = base64.b64decode(image_string)
    base_font_01 = base64.b64decode(font_string_01)
    base_font_02 = base64.b64decode(font_string_02)
    try:
        image01 = Image.open(image)
        image02 = Image.open(logo)
        image03 = Image.open(BytesIO(base_image))
        image04 = changeImageSize(1280, 720, image01)
        image05 = ImageEnhance.Brightness(image04)
        image06 = image05.enhance(1.3)
        image07 = ImageEnhance.Contrast(image06)
        image08 = image07.enhance(1.3)
        image09 = circle_image(image08, 365)
        image10 = circle_image(image02, 90)
        image11 = image08.filter(ImageFilter.GaussianBlur(15))
        image12 = ImageEnhance.Brightness(image11)
        image13 = image12.enhance(0.5)
        image13.paste(image09, (140, 180), mask=image09)
        image13.paste(image10, (410, 450), mask=image10)
        image13.paste(image03, (0, 0), mask=image03)

        font01 = ImageFont.truetype(BytesIO(base_font_01), 45)
        font02 = ImageFont.truetype(BytesIO(base_font_02), 30)
        draw = ImageDraw.Draw(image13)
        para = textwrap.wrap(title, width=28)
        para_size = len(para)
        if para_size == 1:
            title_height = 230
        else:
            title_height = 180
        j = 0
        for line in para:
            if j == 1:
                j += 1
                draw.text((565, 230), f"{line}", fill="white", font=font01)
            if j == 0:
                j += 1
                draw.text((565, title_height), f"{line}", fill="white", font=font01)
        draw.text(
            (565, 320), f"{channel}  |  {views[:23]}", (255, 255, 255), font=font02
        )

        line_length = 580
        line_color = random_color_generator()

        if duration != "Live":
            color_line_percentage = random.uniform(0.15, 0.85)
            color_line_length = int(line_length * color_line_percentage)
            white_line_length = line_length - color_line_length
            start_point_color = (565, 380)
            end_point_color = (565 + color_line_length, 380)
            draw.line([start_point_color, end_point_color], fill=line_color, width=9)
            start_point_white = (565 + color_line_length, 380)
            end_point_white = (565 + line_length, 380)
            draw.line([start_point_white, end_point_white], fill="white", width=8)
            circle_radius = 10
            circle_position = (end_point_color[0], end_point_color[1])
            draw.ellipse(
                [
                    circle_position[0] - circle_radius,
                    circle_position[1] - circle_radius,
                    circle_position[0] + circle_radius,
                    circle_position[1] + circle_radius,
                ],
                fill=line_color,
            )
        else:
            line_color = (255, 0, 0)
            start_point_color = (565, 380)
            end_point_color = (565 + line_length, 380)
            draw.line([start_point_color, end_point_color], fill=line_color, width=9)

            circle_radius = 10
            circle_position = (end_point_color[0], end_point_color[1])
            draw.ellipse(
                [
                    circle_position[0] - circle_radius,
                    circle_position[1] - circle_radius,
                    circle_position[0] + circle_radius,
                    circle_position[1] + circle_radius,
                ],
                fill=line_color,
            )

        draw.text((565, 400), "00:00", (255, 255, 255), font=font02)
        if len(duration) == 4:
            draw.text((1090, 400), duration, (255, 255, 255), font=font02)
        elif len(duration) == 5:
            draw.text((1055, 400), duration, (255, 255, 255), font=font02)
        elif len(duration) == 8:
            draw.text((1015, 400), duration, (255, 255, 255), font=font02)

        image14 = ImageOps.expand(image13, border=10, fill=random_color_generator())
        image15 = changeImageSize(1280, 720, image14)
        image15.save(f"cache/{vidid}_{user_id}.png")
        return f"cache/{vidid}_{user_id}.png"
    except Exception as e:
        logs(__name__).info(f"Thumbnail Error: {e}")
        return START_IMAGE_URL
