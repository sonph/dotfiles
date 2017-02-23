#!/usr/bin/env python3
#
# Change the screen brightness for UL80Vt laptop.
#
# See askubuntu.com/questions/56155
# TODO: Get XF86MonBrightness(Up|Down) keys working before allowing a 00 level
# of brightness.
import argparse
import logging
import re
import sys

from sh import setpci

DEVICE = '00:02.0'
SLOT = 'F4.B'

# Two uppercase hex digits.
VALUE_REGEX = '^[0-9A-F][0-9A-F]$'

# DO NOT set min 0 unless the keyboard shortcuts are working correctly.
MIN_VALUE = 5
MAX_VALUE = 255

# How many levels from full darkness to full brightness, for inc/dec.
LEVELS = 8


def to_hex(value):
  assert isinstance(value, int)
  return hex(value)[2:].upper()


def set_value_hex(value):
  assert re.match(VALUE_REGEX, value)
  assert MIN_VALUE <= int(value, 16) <= MAX_VALUE
  setpci('-s', DEVICE, '%s=%s' % (SLOT, value))


def read_value_hex():
  value = setpci('-s', DEVICE, SLOT)
  logging.info('Read value: %s', value)
  return str(value)


def inc_value():
  current = int(read_value_hex(), 16)
  new = to_hex(min(MAX_VALUE, current + 255 // LEVELS))
  logging.info('New value %s', new)
  set_value_hex(new)


def dec_value():
  current = int(read_value_hex(), 16)
  new = to_hex(max(MIN_VALUE, current - 255 // LEVELS))
  logging.info('New value %s', new)
  set_value_hex(new)


def main():
  parser = argparse.ArgumentParser(description='Increase, decrease or set screen brightness.')
  parser.add_argument('-v', '--verbose', action='store_true', help='verbose output')
  subparsers = parser.add_subparsers(dest='subcommand')
  inc_parser = subparsers.add_parser('inc')
  dec_parser = subparsers.add_parser('dec')
  set_parser = subparsers.add_parser('set')
  set_parser.add_argument('value', type=str, help='hex value to set 00-FF')
  args = parser.parse_args()

  if args.verbose:
    logging.basicConfig(level=logging.INFO)

  if args.subcommand == 'inc':
    inc_value()
  elif args.subcommand == 'dec':
    dec_value()
  elif args.subcommand == 'set':
    set_value_hex(args.value)
  else:
    parser.print_help()

if __name__ == '__main__':
  main()
