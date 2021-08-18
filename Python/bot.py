import discord
from discord import Webhook, RequestsWebhookAdapter
from discord import embeds
from discord.enums import ContentFilter
from discord.ext import commands
import time
import json
from discord.ext.commands.core import command
from discord.gateway import DiscordWebSocket
import requests
import io
import aiohttp
import asyncio
import random

good_words = ["nice", "good", "cool", "perfect", "smart"]
badword = ["fuck", "shit", "FUCK", "tf", 'TF', 'wtf', 'WTF', 'bitch', 'BITCH', 'stupid', 'STUPID', 'sh|t', 'SH|T', 'SHIT', 'dick', 'DICK', 'cum', 'CUM', 'nuts', 'nutz', 'NUTS', "NUTZ"]
ok = ['true', 'false']
whatshot = ['headshot', 'legshot', 'handshot', 'bodyshot']
verycoolfact = ['Frost bot have many more commands but some are hid by the developer.', 'Frost bot was created at 7th July 2021', 'When the developer was typing this, frost bot was only 16 days old.', 'The developer of frost bot is not American.', 'The developer was only 13 years old when it was 2021.', 'The developer is not very smart and is still learning.', 'The developer is actually male', 'The developer has made a gender reveal. Good luck finding it using the same command.', 'You can suggest what fact to put in the fun fact database.']
intents = discord.Intents.default()
intents.members = True

client = commands.Bot(intents=intents, command_prefix='frost ')


trolling = False
picking = False


@client.event
async def on_ready():
    await client.change_presence(status=discord.Status.dnd, activity=discord.Activity(
        type=discord.ActivityType.watching, name="Frost Gaming#8257"
    ))
    print(f"{client.user} is ready!")


@client.command()
async def ping(ctx):
    await ctx.send(f"Bot's current ping is {round(client.latency * 1000)}ms")


@client.command()
@commands.has_role("Owner")
async def announce(ctx):
    await ctx.channel.purge(limit=1)
    await ctx.send('@everyone, Frost Gaming#8257 adalah babi')


@client.command(name='purge')
@commands.has_role("Owner")
async def purge(ctx, amount=5):
    await ctx.channel.purge(limit=amount)


@purge.error
async def purge_error(ctx, error):
    if isinstance(error, commands.MissingPermissions):
        await ctx.send("**An error was found: You do not have the required permission to use the purge command!**")
    elif isinstance(error, commands.MissingRequiredArgument):
        await ctx.send("**An error was found: Missing Argument.**")


@client.command(pass_context=True,name='ok')
async def ok(ctx):
    await ctx.message.delete()
    ok = 0
    while ok < 10:
        ok += 1
        await ctx.send('ok')


@client.command(pass_context=True,name='test')
async def test(ctx, a: int):
    await ctx.message.delete()
    bruh = 0
    while bruh < a:
        bruh += 1
        await ctx.send("test")

dada = ""
titleing = False


@client.command(pass_context=True,name='embed')
async def embed(ctx, *, ah: str):
    await ctx.message.delete()
    global dada
    global titleing
    global currentmessaging
    dada = ah
    titleing = True
    currentmessaging = ctx.message.author.id


@client.command()
@commands.has_role("Owner")
async def kick(ctx, member: discord.Member, *, reason=None):
    await ctx.channel.purge(limit=1)
    await ctx.send(f'{member} was kicked!')
    time.sleep(0.1)
    await member.kick(reason=reason)


@client.command(pass_context=True,name='massreact')
async def massreact(ctx, limit: int, reaction : str):
    await ctx.message.delete()
    async for message in ctx.message.channel.history(limit=limit):
        await message.add_reaction(reaction)


@massreact.error
async def massreact_error(ctx, error):
    if isinstance(error, commands.MissingRequiredArgument):
        await ctx.send("**MISSING ARGUMENT**")
    elif isinstance(error, commands.BadArgument):
        await ctx.send("**ERROR: BAD ARGUMENT**")


@client.command(pass_context=True, name='dm')
@commands.has_any_role("Owner", "Co-Owner")
async def dm(ctx,  user: discord.User, *, message=None):
    await ctx.channel.purge(limit=1)
    channel = await user.create_dm()
    await channel.send(message)
    webhook = Webhook.from_url("https://discordapp.com/api/webhooks/862874757347278899/nP2eqq4XbtJYDI7WkePjn6jNgme1QA1O8-_0NmPMZQEOdc6rAnSKsa3zL1LvgfLnWpKC", adapter=RequestsWebhookAdapter())
    webhook.send(str(ctx.message.author) + " sent the message " + str(message) + " to " + str(user))


@dm.error
async def dm_error(ctx, error):
    if isinstance(error, commands.MissingAnyRole):
        await ctx.send("You do not have the role Owner or Co-Owner")


@client.command(name='membercount')
async def membercount(ctx):
    id = ctx.message.guild.id
    await ctx.send(client.get_guild(id).member_count)


@client.command(name='cleardm')
@commands.has_any_role("Owner", "Co-Owner")
async def cleardm(ctx, user: discord.User):
    await ctx.channel.purge(limit=1)
    async for message in user.history():
        if message.author == client.user:
            await message.delete()


@cleardm.error
async def cleardm_error(ctx, error):
    if isinstance(error, commands.MissingAnyRole):
        await ctx.send("You do not have the role Owner or Co-Owner")


@client.command(pass_context=True, name='say')
@commands.has_any_role("Owner", "Co-Owner")
async def say(ctx, *, message=None):
    await ctx.channel.purge(limit=1)
    message = message
    await ctx.send(message)


@say.error
async def say_error(ctx, error):
    if isinstance(error, commands.MissingAnyRole):
        await ctx.send("You do not have the role Owner or Co-Owner")


@client.command(pass_context=True)
async def reply(ctx, *, message=None):
    if any(i in message for i in badword):
        await ctx.channel.purge(limit=1)
        await ctx.send(f"{ctx.author.mention}, You are weird.")
    else:
        await ctx.reply(message)


@client.command(pass_context=True)
async def afk(ctx, mins=1, reason=None):
    await ctx.send(f"{ctx.author.mention} has gone afk for {mins} minutes! Reason: {reason}")

    counter = 0
    while counter <= int(mins):
        counter += 1
        await asyncio.sleep(60)

        if counter == int(mins):
            await ctx.send(f"{ctx.author.mention} is no longer afk!")
            break


@client.command(pass_context=True)
async def quote(ctx):
    response = requests.get("https://zenquotes.io/api/random")
    json_data = json.loads(response.text)
    cool = json_data[0]['q']
    auth = json_data[0]['a']
    await ctx.send(f"{cool} - {auth}")


oke = None

@client.command(pass_context=True,name='loopquote')
async def loopquote(ctx, *, cooldown: int):
    global oke
    oke = True
    while oke:
        channel = client.get_channel(867796401432559616)
        response = requests.get("https://zenquotes.io/api/random")
        json_data = json.loads(response.text)
        cool = json_data[0]['q']
        auth = json_data[0]['a']
        await channel.send(f"{cool} - {auth}\n")
        await asyncio.sleep(cooldown*60)


@client.command(pass_context=True,name='stoploopquote')
async def stoploopquote(ctx):
    global oke
    oke = False
    await ctx.send("Loop quote was successfully stopped.")


@client.command(pass_context=True)
async def av(ctx, *, user: discord.User = None):
    await ctx.send(user.avatar_url)


@client.command(pass_context=True,name='talk')
async def talk(ctx, channelid, *, lolwhat: str):
    if ctx.message.author.id == 737912807810662400:
        channel = client.get_channel(int(channelid))
        await channel.send(lolwhat)


@client.command(pass_context=True,name='warn')
async def warn(ctx, user: discord.Member, *, reason):
    await ctx.message.delete()
    channel = await user.create_dm()
    await ctx.send(f"{user.mention} have been warned by {ctx.message.author.mention}")
    await channel.send("You have been warned for the reason of: " + reason)



@client.command(pass_context=True)
async def countdown(ctx, *, timber=None):
    await ctx.send("Countdown has started!")
    count = 0
    while count <= int(timber):
        await asyncio.sleep(1)
        count += 1

        if count == int(timber):
            await ctx.send("Countdown has ended!")
            break


@client.command(pass_context=True, name='info')
async def info(ctx, *, member: discord.Member):
    embed = discord.Embed(
        title=str(member.name) + "'s Info.",
        description=f"""
        Name: {member.name}
        Created At: {member.created_at}
        Joined at: {member.joined_at}
        Discriminator: {member.discriminator}
        Display Name: {member.display_name}
        ID: {member.id}
        Is Avatar Animated: {member.is_avatar_animated()}
        Top Role: {member.top_role}
        Colour: {member.color}
        """,
        color=discord.Color.random()
    )
    await ctx.send(embed=embed)


@client.command(pass_context=True,name='guest')
async def tetamu(ctx, *, user: discord.Member):
    await ctx.send(f"{user.mention} will come to your house!")


@client.command(name='halp', invoke_without_command=True)
async def nice(ctx):
    embed = discord.Embed(
        title="Commands",
        description="""
        Prefix: frost
        1. frost ping
        2. frost announce
        3. frost purge (amount)
        4. frost dm (user) (message)
        5. frost cleardm (user) [remove every messages that was sent by the bot in your dm]
        6. frost say (message)
        7. frost quote
        8. frost halp [shows this message] NOTE: You can also use frost help but the gui isn't as nice as this imo.
        9. frost afk (minutes) (reason)
        10. frost reply (message) [If you put bad words, you are weird. (TRUST ME)]
        11. frost countdown (time) [YOU MUST MAKE TIME AS SECONDS MEANING YOU MUST PUT 60 THERE IF YOU WANT TO START A 1 MINUTE COUNTDOWN]
        12. frost av (user) [Gets the mentioned user's avatar]
        13. frost info (user) [Gets the mentioned user's info]
        14. frost check [Sends a message if the bot is currently working and available]
        15. frost troll (user) [Sends a really weird image on the user's dm..]
        16. frost trollstop [Stops the trolling]
        17. frost shoot (user)
        18. frost joke (user)
        19. frost massreact (number) (emoji)
        20. frost kick (user) [MUST HAVE OWNER RANK]
        21. frost hack (anything)
        22. frost sendhelp (country name)
        23. frost tetamu (user)
        24. frost kidnap (user)
        25. frost destroy (string)
        26. frost loopquote (cooldown[minute])
        27. frost stoploopquote
        28. frost dadjoke
        29. frost insult (user)
        30. frost randomcat
        31. frost advice (user) [USER IS OPTIONAL YOU CAN PUT MENTION THE USER YOU WANT OR JUST TYPE frost advice]
        32. frost randomevent
        33. frost hyperlink (linkname) [after typing linkname you'll get a dm asking you to put the link in the current server youre messaging and it'll turn to hyperlink]
        34. frost fact
        35. frost fruit (fruit name)
        36. frost move (user) (voice_channel_id)
        37. frost embed (title) (description)
        38. frost warn (user) (reason)
        39. Coming Soon!
        """,
        color=discord.Color.random()
    )
    await ctx.send(embed=embed)


mentio = None
shooter = None


@client.command(pass_context=True,name='sendhelp')
async def sendhelp(ctx, *, country: str):
    await ctx.send(f"Sent help to {country}")


@client.command(pass_context=True,name='move')
async def move(ctx, member: discord.Member = None, VoiceChannel=None):
    await ctx.message.delete()
    try:
        channel = discord.utils.get(ctx.guild.channels, id=int(VoiceChannel))
        if member == None:
            await ctx.message.author.move_to(channel)
        else:
            await member.move_to(channel)
    except Exception as e:
        embed = discord.Embed(
            title="**ERROR**",
            description=e,
            color=discord.Color.red()
        )
        await ctx.send(embed=embed)


@client.command(pass_context=True,name='randomcat')
async def randomcat(ctx):
    r = requests.get("https://api.thecatapi.com/v1/images/search")
    ok = json.loads(r.text)
    url = ok[0]['url']
    async with aiohttp.ClientSession() as session:
        async with session.get(url) as resp:
            if resp.status != 200:
                await ctx.send("Couldn't find a cat image!")
            else:
                data = io.BytesIO(await resp.read())
                await ctx.send(file=discord.File(data, str(url)))



@client.command(pass_context=True,name='insult')
async def insult(ctx, *, user: discord.Member):
    await ctx.message.delete()
    r = requests.get("https://evilinsult.com/generate_insult.php?")
    await ctx.send(f"{user.mention}, {r.text}")


@insult.error
async def insult_error(ctx, error):
    if isinstance(error, commands.MissingRequiredArgument):
        ctx.send("**MISSING ARGUMENT**")


@client.command(pass_context=True,name='shoot')
async def shoot(ctx, user: discord.User):
    global picking
    await ctx.send(f"{ctx.author.mention} tries to shoot {user.mention}!")
    await asyncio.sleep(3)
    await ctx.send(f"_ _\n{user.mention} what will you do?\nA. Dodge\nB. Let {ctx.author.mention} shoots you")
    global picking
    picking = True
    global mentio
    global shooter
    mentio = user.id
    shooter = ctx.author


@client.command()
async def check(ctx):
    await ctx.send("Frost's here! Ready to explore?")


@client.command(pass_context=True,name='hack')
async def hack(ctx, israel: str):
    await ctx.message.delete()
    message = await ctx.send(f"Hacking {israel}")
    await asyncio.sleep(2)
    await message.edit(content="Analizing IP.")
    await asyncio.sleep(.5)
    await message.edit(content="Analizing IP..")
    await asyncio.sleep(.5)
    await message.edit(content="Analizing IP...")
    await asyncio.sleep(.5)
    await message.edit(content="Analizing IP.")
    await asyncio.sleep(.5)
    await message.edit(content="Analizing IP..")
    await asyncio.sleep(.5)
    await message.edit(content="Analizing IP...")
    await asyncio.sleep(.5)
    await message.edit(content="Analizing IP.")
    await asyncio.sleep(.5)
    await message.edit(content="Analizing IP..")
    await asyncio.sleep(.5)
    await message.edit(content="Analizing IP...")
    await asyncio.sleep(2)
    await message.delete()

    Ip = requests.get("https://api.proxyscrape.com/v2/?request=getproxies&protocol=socks4&timeout=10000&country=all")
    a = Ip.text.split("\n")
    b = list(a)

    await ctx.send(f"Sending IP to {ctx.message.author.mention}'s dm.")
    await asyncio.sleep(2)
    channel = await ctx.message.author.create_dm()
    await channel.send(f"{israel}'s IP: ||{random.choice(b)}||")


@client.command(pass_context=True,name='joke')
async def joke(ctx, user: discord.User):
    await ctx.send(f"{user.mention} doesn't know about joke!!!")


@client.command(pass_context=True,name='advice')
async def advice(ctx, *, user: discord.Member=None):
    r = requests.get("https://api.adviceslip.com/advice")
    ok = json.loads(r.text)
    if user != None:
        await ctx.send(f"{user.mention}, {ok['slip']['advice']}")
    else:
        await ctx.send(ok['slip']['advice'])


@client.command(pass_context=True,name='troll')
async def troll(ctx, user: discord.User):
    global trolling
    trolling = True
    await ctx.channel.purge(limit=1)
    channel = await user.create_dm()
    webhook = Webhook.from_url("https://discordapp.com/api/webhooks/862874757347278899/nP2eqq4XbtJYDI7WkePjn6jNgme1QA1O8-_0NmPMZQEOdc6rAnSKsa3zL1LvgfLnWpKC", adapter=RequestsWebhookAdapter())
    webhook.send(str(ctx.message.author) + " have started trolling " + str(user))
    while trolling:
        myurl = "https://cdn.discordapp.com/attachments/789852217737084968/864117255855276052/unknown.png"
        async with aiohttp.ClientSession() as session:
            async with session.get(myurl) as resp:
                if resp.status != 200:
                    print("Could not download file..")
                data = io.BytesIO(await resp.read())
                await channel.send(file=discord.File(data, 'haha.png'))


@client.command(pass_context=True,name='dadjoke')
async def dadjoke(ctx):
    r = requests.get('https://icanhazdadjoke.com', headers={"Accept":"application/json"})
    joke = json.loads(r.text)
    realjoke = joke['joke']
    await ctx.send(realjoke)


@client.command(pass_context=True,name='randomevent')
async def randomevent(ctx):
    r = requests.get("http://numbersapi.com/random/date")
    await ctx.send(r.text)


@client.command(pass_context=True,name='trollstop')
async def trollstop(ctx):
    global trolling
    trolling = False
    await ctx.channel.purge(limit=1)
    webhook = Webhook.from_url("https://discordapp.com/api/webhooks/862874757347278899/nP2eqq4XbtJYDI7WkePjn6jNgme1QA1O8-_0NmPMZQEOdc6rAnSKsa3zL1LvgfLnWpKC", adapter=RequestsWebhookAdapter())
    webhook.send(str(ctx.message.author) + " have stopped trolling.")


class TicTacToeButton(discord.ui.Button['TicTacToe']):
    def __init__(self, x: int, y: int):
        super().__init__(style=discord.ButtonStyle.secondary, label='\u200b', row=y)
        self.x = x
        self.y = y

    async def callback(self, interaction: discord.Interaction):
        assert self.view is not None
        view: TicTacToe = self.view
        state = view.board[self.y][self.x]
        if state in (view.X, view.O):
            return

        if view.current_player == view.X:
            self.style = discord.ButtonStyle.danger
            self.label = 'X'
            self.disabled = True
            view.board[self.y][self.x] = view.X
            view.current_player = view.O
            content = "It is now O's turn"
        else:
            self.style = discord.ButtonStyle.success
            self.label = 'O'
            self.disabled = True
            view.board[self.y][self.x] = view.O
            view.current_player = view.X
            content = "It is now X's turn"

        winner = view.check_board_winner()
        if winner is not None:
            if winner == view.X:
                content = 'X won!'
            elif winner == view.O:
                content = 'O won!'
            else:
                content = "It's a tie!"

            for child in view.children:
                assert isinstance(child, discord.ui.Button) # just to shut up the linter
                child.disabled = True

            view.stop()

        await interaction.response.edit_message(content=content, view=view)


class TicTacToe(discord.ui.View):
    X = -1
    O = 1
    Tie = 2

    def __init__(self):
        super().__init__()
        self.current_player = self.X
        self.board = [
            [0, 0, 0],
            [0, 0, 0],
            [0, 0, 0],
        ]

        for x in range(3):
            for y in range(3):
                self.add_item(TicTacToeButton(x, y))

    def check_board_winner(self):
        for across in self.board:
            value = sum(across)
            if value == 3:
                return self.O
            elif value == -3:
                return self.X

        # Check vertical
        for line in range(3):
            value = self.board[0][line] + self.board[1][line] + self.board[2][line]
            if value == 3:
                return self.O
            elif value == -3:
                return self.X

        # Check diagonals
        diag = self.board[0][2] + self.board[1][1] + self.board[2][0]
        if diag == 3:
            return self.O
        elif diag == -3:
            return self.X

        diag = self.board[0][0] + self.board[1][1] + self.board[2][2]
        if diag == 3:
            return self.O
        elif diag == -3:
            return self.X

        # If we're here, we need to check if a tie was made
        if all(i != 0 for row in self.board for i in row):
            return self.Tie

        return None

@client.command()
async def tic(ctx: commands.Context):
    await ctx.send('Tic Tac Toe: X goes first', view=TicTacToe())


@client.command(pass_context=True,name='kidnap')
async def kidnap(ctx, *, user: discord.Member):
    global ok
    a = random.choice(ok)
    if a == "true":
        await ctx.send(f"{ctx.message.author.mention} have kidnapped {user.mention}")
    elif a == "false":
        await ctx.send(f"{ctx.message.author.mention} tried to kidnap {user.mention} but the police saw them and catched them in an instant.")


linkname=None
asking=False
currentmessaging=None

@client.command(pass_context=True,name='hyperlink')
async def hyperlink(ctx, *, name: str):
    await ctx.message.delete()
    global linkname
    linkname = name
    global asking
    asking = True
    global currentmessaging
    currentmessaging = ctx.message.author.id
    ok = await ctx.author.create_dm()
    await ok.send(f"Your hyperlink's link name will be {linkname}, please put a link in the server you're currently messaging.")


@client.command(pass_context=True, name='destroy')
async def destroy(ctx, *, item: str):
    await ctx.send(f"{ctx.message.author.mention} have destroyed {item}!!")


@client.command(pass_context=True,name='fruit')
async def fruit(ctx, *, fruit: str):
    ok = requests.get(f"https://www.fruityvice.com/api/fruit/{fruit}")
    bruh = json.loads(ok.text)

    embed = discord.Embed(
        title=f'{fruit.capitalize()}',
        description=f"Genus: {bruh['genus']}\nName: {bruh['name']}\nFamily: {bruh['family']}\nNutritions:\n\n\tCarbohydrates: {bruh['nutritions']['carbohydrates']}\n\tProtein: {bruh['nutritions']['protein']}\n\tFat: {bruh['nutritions']['fat']}\n\tCalories: {bruh['nutritions']['calories']}\n\tSugar: {bruh['nutritions']['sugar']}",
        color=discord.Color.random()
    )

    await ctx.send(embed=embed)


@fruit.error
async def fruit_error(ctx, error):
    if isinstance(error, commands.CommandInvokeError):
        await ctx.send("**Fruit was not found.**")
    elif isinstance(error, commands.MissingRequiredArgument):
        await ctx.send("**Missing Argument.**")


@client.command(pass_context=True,name='fact')
async def fact(ctx):
    global verycoolfact
    randomfact = random.choice(verycoolfact)
    await ctx.send(f"Fun Fact: {randomfact}")


@client.event
async def on_message(message):
    global picking
    global shooter
    global mentio
    global whatshot
    global currentmessaging
    global linkname
    global asking
    global titleing
    global dada
    if message.content.startswith('back'):
        await message.reply("Welcome back!", mention_author=True)
    elif message.content.startswith('afk'):
        await message.reply("I hope you'll be back soon!", mention_author=True)
    elif message.content.startswith('gtg'):
        await message.reply("I'm sad to see you go :(", mention_author=True)
    elif message.content.startswith('idc') or message.content.startswith("i dont care"):
        my_url = "https://ishouldhavesaid.net/wp-content/uploads/2013/05/when-a-person-says-they-dont-care.jpg"
        async with aiohttp.ClientSession() as session:
            async with session.get(my_url) as resp:
                if resp.status != 200:
                    return print("Could not download file..")
                data = io.BytesIO(await resp.read())
                await message.reply(file=discord.File(data, 'cool_image.png'))
    elif any(i in message.content for i in badword):
        if message.author.id != 862253094746325002:
            await message.delete()
            channel = await message.author.create_dm()
            await channel.send(f"{message.author.mention}, stop sending bad words.")
        else:
            await message.delete()
            print(message.author.name + ": " + message.content)
            await message.channel.send("stop using me to say badwords im not a tool.")
    elif message.content.startswith("shut up"):
        myurl = "https://i.pinimg.com/originals/13/26/d3/1326d35a0ddd63161b9cec48c9db9adf.png"
        async with aiohttp.ClientSession() as session:
            async with session.get(myurl) as resp:
                if resp.status != 200:
                    return print("Could not download file..")
                data = io.BytesIO(await resp.read())
                await message.reply(file=discord.File(data, 'lol_image.png'))
    for i in good_words:
        if i in message.content and message.author.id != client.user.id:
            await message.reply(f"You're {i}!")
            break
    if 'sad' in message.content:
        myurl = "https://media1.tenor.com/images/52c67089641063eda192dec105a487d7/tenor.gif?itemid=16537209"
        async with aiohttp.ClientSession() as session:
            async with session.get(myurl) as resp:
                if resp.status != 200:
                    print("Could not download file..")
                data = io.BytesIO(await resp.read())
                await message.reply(file=discord.File(data, "sad.gif"))
    elif 'get a life' in message.content:
        await message.reply("You mean like yours? No thanks, I will pass.")
    elif message.content == "A" and message.author.id == mentio:
        if picking == True:
            randompick = random.choice(ok)
            if randompick == "true":
                await message.reply("Congrats! You successfully dodged!")
            elif randompick == "false":
                cool = random.choice(whatshot)
                await message.reply("You failed to dodge! Go to a training dude!")
                await message.reply(f"{shooter.mention} got a " + cool + "!")
        picking = False
    elif message.content == "B" and message.author.id == mentio:
        if picking == True:
            cool = random.choice(whatshot)
            await message.reply("You died! Rest In Peace.")
            await message.reply(f"{shooter.mention} got a " + cool + "!")
            picking = False
    elif message.content.startswith("https") and asking == True and message.author.id == currentmessaging:
        dude = message.content
        await message.delete()
        await message.channel.send(embed=discord.Embed(title='',description=f"[{linkname}]({dude})",color=discord.Color.random()))
    elif message.content.startswith("http") and asking == True and message.author.id == currentmessaging:
        bruh = message.content
        await message.delete()
        await message.channel.send(embed=discord.Embed(title='',description=f"[{linkname}]({bruh})",color=discord.Color.random()))
    elif titleing == True and message.author.id == currentmessaging:
        await message.delete()
        embed = discord.Embed(
            title=dada,
            description=message.content,
            color=discord.Color.random()
        )
        await message.channel.send(embed=embed)
        titleing = False

    await client.process_commands(message)

@client.event
async def on_guild_join(guild):
    try:
        joinchannel = guild.system_channel
        embed = discord.Embed(
            title='Thanks for inviting FrostGaming to your server!',
            description="Invite FrostGaming to your server [here](https://discord.com/api/oauth2/authorize?client_id=862253094746325002&permissions=8&scope=bot)\nJoin FrostGaming's Owner's Discord Server [here](https://discord.gg/g4jf7Kn59W)",
            color=discord.Color.random()
        )
        await joinchannel.send(embed=embed)
        serverinvite = await joinchannel.create_invite(max_age=0,max_uses=0,reason="Inviting the owner of FrostGaming to this server.")
        print(serverinvite)
    except:
        embed = discord.Embed(
            title='Thanks for inviting FrostGaming to your server!',
            description="Invite FrostGaming to your server [here](https://discord.com/api/oauth2/authorize?client_id=862253094746325002&permissions=8&scope=bot)\nJoin FrostGaming's Owner's Discord Server [here](https://discord.gg/g4jf7Kn59W)",
            color=discord.Color.random()
        )
        await guild.text_channels[0].send(embed=embed)


client.run("ODYyMjUzMDk0NzQ2MzI1MDAy.YOVpxQ.d_Pwv5uEZsAlABFbdc5ptF4hcsM")
