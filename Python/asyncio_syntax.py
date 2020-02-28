'''
simplest example, only here to show the syntax
'''

import asyncio

async def f():
    print("called f")
    return True

async def g():
    # Pause here and come back to g() when f() is ready
    r = await f()
    return r


if __name__ == "__main__":
    asyncio.run(g()) # Add to an event loop