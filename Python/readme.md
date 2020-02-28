# Hint Code for Project

## Python Basics

- [dict_and_class.py](./dict_and_class.py): The use of Python data structures like dictionary and class.
- [message_hint.py](./message_hint.py): An example showing how you could handle message elegantly with classes. Not necessarily implemented this way, message handlers could be integrated directly into your server-class; or you could do without any class. It is also doable if you don't use class at all.

## asyncio Basics

- [asyncio_basic.py](./asyncio_basic.py): asyncio basic usage.
- [asyncio_mutual.py](./asyncio_mutual.py): another silly example.
- (\*) [asyncio_advanced.py](./asyncio_advanced.py): more advanced usage that is not really required for this project.
- [echo_server.py](./echo_server.py) and [echo_client.py](./echo_client.py)
    * usage: ```python echo_server.py Hello``` and then ```python echo_client.py```
    * could be other names for the server, I am including the name option as a must so as to show you how to use the command line arguments (required for this project).
    * they are the real starter hints for this project.

## The Flooding Algorithm

- [flooding_hint.py](./flooding_hint.py): the idea of the floading algorithm in general, but shouldn't be how it is implemented in the end, please consider asyncio.
- More hints: you can consider using timestamp to tell if a message is already received & processed by the current server!
- How to store the messages received? Completely up to you. e.g. a dictionary, a list, another object of your self-defined class, etc.

## The json Format

- [json_hint.py](./json_hint.py): if you are not familiar with json format (will need it for the map API part), please check it out here.

## How to test your code

- Check the [sample grading scripts](https://github.com/CS131-TA-team/CS131-Project-Sample-Grading-Script)
- Obviously it is not the real grading scripts, but the components I use to check for the correctness are almost the same (scoring function is not the same --- the version you see here is obviously an intermediate version, and in the current version, you should expect all outputs be "True")
- Do not ask for your friends' code from previous quarters, we are changing the test cases.
- Be sure to implement **whatever the spec requests**.
- An **important** suggestion: please avoid using json file / txt file as configuration file! If you want to put your API keys into a separated file, try using *config.py* to hold it! Also, if you put your log file into a folder, please write the logic of **creating** that folder as well!
- Only if when you put your *server.py* under the sample submission folder, and **directly** set it to run, without any additional action required, your script is safe to submit.
- Please design your own test cases using the sample grading script we offer you. The existing samples for now are too naive.
