import logging


logging.basicConfig(
    level=logging.INFO,
    format='%(levelname)s: %(message)s'
)

def log(msg):
    logging.info(f"{msg}")
