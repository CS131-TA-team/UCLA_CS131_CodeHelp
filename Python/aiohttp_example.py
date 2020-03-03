import asyncio
import aiohttp

API_KEY = '<your_key>'
latitude = "+34.068930"
longitude = "-118.445127"
loc = "{0},{1}".format(latitude, longitude)
rad = 10

url = 'https://maps.googleapis.com/maps/api/place/nearbysearch/json?key={0}&location={1}&radius={2}'.format(API_KEY, loc, rad)


async def simple_case(url):
    async with aiohttp.ClientSession(
        connector=aiohttp.TCPConnector(
            ssl=False,
        ),
    ) as session:
        async with session.get(url) as resp:
            response = await resp.json()
            print(response)


asyncio.run(simple_case(url))