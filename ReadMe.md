# Routster

Simple script to find routes from given input. Tried to solve [this exercise](https://gist.github.com/jjanauskas/8cfdb6fc03b14a2a224d)

# About my code

Unfortunately i did not have enough time to create a good algorithm so my code only finds routes without repeating stops e.g ABCDC. Maybe i have chosen a wrong way to do that. I do believe that it is possible to create only one method to find all possible routes without filtering (i use 2 methods - one to get hash of all possible routes, second - to get arrays for each routes with all necessary data).

# Usage

## Distance for

    rake routster:distance ROUTES=AC1,CD2,DE1,AD2 ROUTE=A-C-D

## Trips

    rake routster:trips ROUTES=AB5,AB3,BC2,EA2 START=A STOP=C COUNT=2 PRECISE=exactly KIND=stops

## Shortest route

    rake routster:shortcut ROUTES=AB5,AB3,BC2,EA2 START=A STOP=C

# Testing

You can run specs to see the results. I changed results for some tasks (6, 7, 10) because of the reasons described above. To start specs do:

    rake spec