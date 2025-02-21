#include <stdio.h>

#define F 3            // Number of floors
#define S 2            // Number of sections per floor
#define SECTION_MAX 12 // Maximum number of cars per section

int main(void) {
    // Initial number of cars per section
    int parking[F][S] = { {8, 8}, {8, 8}, {8, 8} };

    // Array representing cars entering the car park at different times
    int entering[5] = {1, 2, 3, 4, 5};

    // Array representing cars exiting from each section at the end of the day
    int exiting[F][S] = { {1, 2}, {2, 3}, {3, 4} };

    int floor = 0;  // Current floor pointer
    int sec = 0;    // Current section pointer
    int event, cars, available;

    // Process each entering event
    for (event = 0; event < 5; event++) {
        cars = entering[event];
        // While there are still cars to allocate and there are available floors
        while (cars > 0 && floor < F) {
            available = SECTION_MAX - parking[floor][sec];
            if (available > 0) {
                if (cars <= available) {
                    parking[floor][sec] += cars;
                    cars = 0;  // All incoming cars for this event have been parked
                } else {
                    parking[floor][sec] = SECTION_MAX;
                    cars -= available;
                    // Move to the next section after filling the current one
                    sec++;
                    if (sec >= S) { // If current floor is full, move to the next floor
                        sec = 0;
                        floor++;
                    }
                }
            } else {
                // Current section is full; move to the next section
                sec++;
                if (sec >= S) {
                    sec = 0;
                    floor++;
                }
            }
        }
        // If the entire car park is full (floor >= F), any remaining cars in this event are discarded.
    }

    // Process each exiting event for each section
    for (floor = 0; floor < F; floor++) {
        for (sec = 0; sec < S; sec++) {
            // Ensure we do not subtract more cars than are present in the section
            if (exiting[floor][sec] > parking[floor][sec]) {
                parking[floor][sec] = 0;
            } else {
                parking[floor][sec] -= exiting[floor][sec];
            }
        }
    }

    // Print the final state of the parking lot
    printf("Final parking state:\n");
    for (floor = 0; floor < F; floor++) {
        for (sec = 0; sec < S; sec++) {
            printf("%d ", parking[floor][sec]);
        }
        printf("\n");
    }

    return 0;
}
