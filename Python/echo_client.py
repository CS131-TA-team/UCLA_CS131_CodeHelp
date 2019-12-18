'''
Note that this piece of code is (of course) only a hint
you are not required to use it
neither do you have to use any of the methods mentioned here
The code comes from 
https://asyncio.readthedocs.io/en/latest/tcp_echo.html

To run: 
1. start the echo_server.py first in a terminal
2. start the echo_client.py in another terminal
3. follow print-back instructions on client side until you quit
'''

import asyncio
import argparse

class Client:
    def __init__(self, ip='127.0.0.1', port=8888, name='client', message_max_length=1e6):
        '''
        127.0.0.1 is the localhost
        port could be any port
        '''
        self.ip = ip
        self.port = port
        self.name = name
        self.message_max_length = int(message_max_length)

    async def tcp_echo_client(self, message, loop):
        '''
        on client side send the message for echo
        '''
        reader, writer = await asyncio.open_connection(self.ip, self.port,
                                                       loop=loop)
        print('{} send: {}'.format(self.name, message))
        writer.write(message.encode())

        data = await reader.read(self.message_max_length)
        print('{} received: {}'.format(self.name, data.decode()))

        print('close the socket')
        writer.close()

    def run_until_quit(self):
        # start the loop
        loop = asyncio.get_event_loop()
        while True:
            # collect the message to send
            message = input("Please input the next message to send: ")
            if message in ['quit', 'exit', ':q', 'exit;', 'quit;', 'exit()', '(exit)']:
                break
            else:
                loop.run_until_complete(self.tcp_echo_client(message, loop))
        loop.close()

if __name__ == '__main__':
    client = Client() # using the default settings
    client.run_until_quit()
    
    
    
    