from ecs_pipelines.sources import dummy
import logging

def run():
    for message in dummy.run():
        logging.info(f'stream message: {message}')