import discord
from discord import activity
from discord.embeds import EmptyEmbed 
from discord.ext import commands 
import asyncio 
import datetime
import sys 
import sqlite3
import time
from discord.utils import get
import pyodbc

intents = discord.Intents.default()
intents.members = True

client = commands.Bot(command_prefix='.', case_insensitive=True, intents = intents)

real_chan_id = 913120521175044226


@client.event
async def on_ready():
    print('bot aktif')
    
    return await client.change_presence(activity=discord.Activity(type=1, name='Test', url='https://www.youtube.com/channel/UC61J3SajYQm_OXXx2jp6l4g'))



@client.command()
async def esle(ctx, code):
    if ctx.channel.id == real_chan_id:
        if code != None:
            db = sqlite3.connect(r'C:\Users\furfatsev\Desktop\melanciastories\mods\deathmatch\databases\global\main_erp.db')
            cursor = db.cursor()
            cursor.execute(f"SELECT * FROM hesapesleme")
            results = cursor.fetchall()
            if results != None:
                for v in results:
                    if v[0] == code:
                        if v[1] == "" and v[2] == "":
                            author_name = ctx.message.author.name
                            author_id = ctx.message.author.id
                            author_id = str(author_id)
                            member = ctx.message.author
                            role = get(member.guild.roles, id=808765045063811072)
                            await member.add_roles(role)
                            cursor.execute(f'UPDATE hesapesleme SET userid = {author_id}, userdcname = "{author_name}" WHERE mtaacname = "{v[3]}"')
                            db.commit()
                            await ctx.send(f'Başarıyla discord hesabınız ile MTA:SA hesabınız arasında entegrasyon sağlandı.({author_name} - {v[3]})', delete_after=3)

                        else:
                            await ctx.send(f'Hesabın zaten [{v[3]}] isimli oyun içi hesaba bağlı!', delete_after=3)
            else:
                await ctx.send('Sunucudan kaynaklı bir sorun meydana geldi.', delete_after=3)
        else: 
            await ctx.send('Lütfen kodu giriniz.', delete_after=3)
    else:
        await ctx.send('Lütfen doğru kanalda yazınız.', delete_after=3)
    await ctx.message.delete()
    time.sleep(5)

@client.command()
async def adm_findAlts(ctx, user):
    if user != None:
        db = sqlite3.connect(r'C:\Users\furfatsev\Desktop\melanciastories\mods\deathmatch\databases\global\main_erp.db')
        cursor = db.cursor()
        cursor.execute(f'SELECT * FROM hesapesleme')
        results = cursor.fetchall()
        if results != None:
            for key in results:
                if v[1] == user:
                    if v[0] != None:
                        name = user.split('-')[0]
                        await ctx.send(f'İlgili kişinin oyun hesabı : {name}')
                        await ctx.send(f'Hesap ID : {row["id"]}')
                        
                 
client.run('OTE3MDg3MTg5NjY4NjE4Mjgx.YazmAA.bFQxAuC1I0USs9BkV8_fDcPJgqk')
