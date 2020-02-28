import asyncio
import contextvars

# declare context var
request_id = contextvars.ContextVar('Id of request.')


async def some_inner_coroutine():
    # get value
    print('Processed inner coroutine of request: {}'.format(request_id.get()))


async def some_outer_coroutine(req_id):
    # set value
    request_id.set(req_id)

    await some_inner_coroutine()

    # get value
    print('Processed outer coroutine of request: {}'.format(request_id.get()))


async def main():
    tasks = []
    for req_id in range(1, 5):
        tasks.append(asyncio.create_task(some_outer_coroutine(req_id)))

    await asyncio.gather(*tasks)


if __name__ == '__main__':
    asyncio.run(main())