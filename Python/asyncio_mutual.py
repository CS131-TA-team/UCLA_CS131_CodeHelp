'''
another silly example
'''

import asyncio
import time

def ending_condition(num, odd_or_even="odd"):
    if num > 1: return None
    if (num == 1 and odd_or_even == "odd") or (num == 1 and odd_or_even == "even"): return True
    return False

async def is_odd(num):
    ends = ending_condition(num, "odd") 
    if ends is not None:
        return ends
    else:
        return not await is_even(num - 1)

async def is_even(num):
    ends = ending_condition(num, "even") 
    if ends is not None:
        return ends
    else:
        return not await is_odd(num - 1)

async def main(num):
    if not isinstance(num, int):
        print("I can only handle integers")
    elif num < 0:
        print("I can't handle negative number")
    else:
        odd_flag = await is_odd(num)
        print("{0} is {1}".format(num, "odd" if odd_flag else "even"))

if __name__ == "__main__":
    s = time.perf_counter()
    asyncio.run(main(10)) # Add to an event loop
    elapsed = time.perf_counter() - s
    print(f"{__file__} executed in {elapsed:0.2f} seconds.")