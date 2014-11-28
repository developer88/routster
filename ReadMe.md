# Routster

Simple script to find routes from given input.

# About my code

Unfortunately i did not have time to create a perfect algorithm so my code only find routes without repeating stops e.g ABCDC

You can start specs to see the results. I changed results for some tasks (6, 7, 10) because of the reason described above.

# Usage

## Distance for

    rake routster:distance ROUTES=AB5,AB3,BC2,EA2 ROUTE=A-C

## Trips

    rake routster:trips ROUTES=AB5,AB3,BC2,EA2 START=A STOP=C COUNT=2 PRECISE=exactly KIND=stops

## Shortest route

    rake routster:shortcut ROUTES=AB5,AB3,BC2,EA2 START=A STOP=C


# Testing

I wrote some RSpec test so start them with 'rake spec' command:

    rake spec