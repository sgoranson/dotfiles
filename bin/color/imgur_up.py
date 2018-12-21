#!/usr/bin/env python3

import argparse
import os
from imgurpython import ImgurClient
from imgurpython.helpers.error import ImgurClientError


client_id = '4460f9effc38b24'
client_secret = '4c863959b066947b7e766caac397f55b3b6c032d'
img_data = None

client = ImgurClient(client_id, client_secret)

if __name__ == '__main__':
    parser = argparse.ArgumentParser(description='imgur upload')
    # parser.add_argument('--img', action='store', type=str, dest='img')
    parser.add_argument('img', type=str, help='path to the image')
    given_args = parser.parse_args()
    img_path = given_args.img

    # import pdb; pdb.set_trace()

    if not os.path.isfile(img_path):
        print('%s does not exist or is not a file' % (img_path))
        exit(1)

    try:
        img_data = client.upload_from_path(img_path)
    except ImgurClientError as e:
        print(e.error_message)
        print(e.status_code)
        exit(1)

    print('\n\nDun! \n\nurl: {0}\n'.format(img_data['link']))
