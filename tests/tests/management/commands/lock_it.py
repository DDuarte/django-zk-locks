import time

from django.core.management.base import BaseCommand

import zookeeper_locks


class Command(BaseCommand):
    help = "Lock it!"

    def add_arguments(self, parser):
        parser.add_argument("lock_name", help="lock name to be used")
        parser.add_argument(
            "-d", "--duration", default=10, help="Lock duration (in seconds)"
        )

    def handle(self, *args, **options):
        with zookeeper_locks.lock(options["lock_name"]):
            self.stdout.write(f'Got the lock, sleeping {options["duration"]} seconds')
            time.sleep(options["duration"])
            self.stdout.write("Releasing lock")
