# Routster

Simple script to find routes from given input.

# About my code

Unfortunately i did not have enough time to create a good algorithm so my code only find routes without repeating stops e.g ABCDC. Maybe i have chosen a wrong way to do that. I do believe that it is possible to create only one method to find all possible routes without filtering (i use 2 methods, one to get hash of all possible routes, second is to get arrays for each routes with all nesessary data).

You can run specs to see the results. I changed results for some tasks (6, 7, 10) because of the reason described above.

# Usage

## Distance for

    rake routster:distance ROUTES=AC1,CD2,DE1,AD2 ROUTE=A-C-D

## Trips

    rake routster:trips ROUTES=AB5,AB3,BC2,EA2 START=A STOP=C COUNT=2 PRECISE=exactly KIND=stops

## Shortest route

    rake routster:shortcut ROUTES=AB5,AB3,BC2,EA2 START=A STOP=C

# Testing

I wrote some RSpec test so start them with 'rake spec' command:

    rake spec