"""
hint specifically on message contents and how to deal with them
again, this is not the final answer, not even necessarily part of the final answer
not even close to the right answer, nothing is handled carefully
"""

import time
import json


class ClientMessage:
    def __init__(self, client_id="kiwi.cs.ucla.edu", coordinates="+34.068930-118.445127"):
        self.client_id = client_id
        self.coordinates = coordinates

    def text(self, command_name, **kwargs):
        command_table = {
            'IAMAT': self.i_am_at(),
            'WHATSAT': self.whats_at(**kwargs)
        }
        return command_table.get(command_name, "")

    def i_am_at(self):
        """
        reporting where am I at
        """
        return f"IAMAT {self.client_id} {self.coordinates} {time.time()}"

    def whats_at(self, another_client=None, radius=0, max_results=0):
        """
        get at most max_results places within the radius centered around another client
        those locations are expected to be given by Google Map
        the unit of radius is kilometer
        """
        if another_client is None:
            another_client = self.client_id
        return f"WHATSAT {another_client} {radius} {max_results}"


class ServerMessage:
    history = dict()

    def __init__(self, server_name="whatever_server"):
        self.server_name = server_name
        self.known_command = ["WHATSAT", "IAMAT"]

    def __call__(self, message):
        return self.parse_message(message) if len(message) else "ERROR: empty message"

    def parse_message(self, message):
        command_table = {
            "IAMAT": self.handle_i_am_at,
            "WHATSAT": self.handle_whats_at
        }
        message_list = [msg for msg in message.strip().split() if len(msg)]
        if len(message_list) != 4:
            return "ERROR: invalid command length"
        cmd = command_table.get(message_list[0], lambda x, y, z: f"ERROR: command name {message_list[0]} unrecognized")
        return cmd(*message_list[1:])

    def handle_i_am_at(self, client_id, coordinates, timestamp):
        time.sleep(2)  # sleep 2 seconds
        msg = f"AT {self.server_name} +{time.time() - float(timestamp)} {client_id} {coordinates} {timestamp}"
        ServerMessage.history[client_id] = msg
        return msg

    def handle_whats_at(self, client_id, radius, max_results):
        nonsense_json = ['foo', {'bar': ['baz', None, 1.0, 2]}]
        google_api_feedback = json.dumps(nonsense_json, indent=4)
        return ServerMessage.history[client_id] + "\n" + google_api_feedback


if __name__ == '__main__':
    client_message = ClientMessage(client_id="whatever_name")
    print(client_message.text("IAMAT"))
    print(client_message.text("WHATSAT", another_client="kiwi.cs.ucla.edu", radius=10, max_results=5))
    server_message = ServerMessage()
    print(server_message(client_message.text("IAMAT")))
    print(server_message(client_message.text("WHATSAT")))

