#include <stdio.h>

#define SECTION_MAX 12

// Updated function that minimises temporary variables and reuses registers.
// Assumes that result[0] and result[1] contain F and S respectively.
void asm_func(int* building, int* entry, int* exit, int* result) {
    int total = result[0][0] * result[0][1]; // total sections = F * S
    int i, j, k, l = 0;

    // 1. Copy the initial building state into result.
    for (i = 0; i < total; i++) {
        result[i] = building[i];
    }

    // 2. Process entry events.
    // For each of the 5 entry events, distribute cars in order.
    for (j = 0; j < 5; j++) {
        int cars = entry[j];
        while (cars && k < total) {
            // Calculate the remaining capacity in the current section.
            if (SECTION_MAX - result[k] <= 0) {
                // Current section is full; move to next.
                k++;
            } else if (cars <= (SECTION_MAX - result[k])) {
                // All incoming cars fit in the current section.
                result[k] += cars;
                cars = 0;
            } else {
                // Fill the current section completely and move to the next.
                cars -= (SECTION_MAX - result[k]);
                result[k] = SECTION_MAX;
                k++;
            }
        }
        // If all sections are full, leftover cars are simply discarded.
    }

    // 3. Process exit events.
    // Subtract the exit numbers from each section, ensuring no negative count.
    for (l = 0; l < total; l++) {
        int remaining = result[l] - exit[l];
        result[l] = (remaining < 0) ? 0 : remaining;
    }
}
