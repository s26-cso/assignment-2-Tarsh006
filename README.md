[![Review Assignment Due Date](https://classroom.github.com/assets/deadline-readme-button-22041afd0340ce965d47ae6ef1cefeee28c7c493a6346c4f15d667ab976d596c.svg)](https://classroom.github.com/a/d5nOy1eX)


Part A: The "Sticky Note" Exploit (Static Analysis)

Think of the binary like a locked building. In Part A, instead of trying to pick the lock, we just walked around the building and found the password written on a sticky note stuck to the window.

The Logic:

    The Flaw: When C code is compiled into a binary, all the hardcoded text strings (like "Enter password:" or "You have passed!") get shoved into one specific chunk of memory together (the .rodata section).

    The Strategy: We knew the program was going to print "You have passed!" if we won. So, instead of reading through 10,000 lines of gibberish using the strings command, we used grep -B 5 -A 5 to say: "Hey, find the success message, and show me the 5 lines of memory directly above and below it."

    The Kill: Because programmers are lazy and compilers group strings together, the plain-text password was sitting right next to the success message in the binary’s memory. We grabbed it, pasted it in, and the program let us right through the front door.

Part B: The "Hotwire" Exploit (Stack Buffer Overflow)

In Part B, they fixed the sticky note problem and completely removed the password from the code. The front door was actually bolted shut this time. So, we stopped trying to use the door and just blew a hole through the wall.

The Logic:

    The Flaw: The program asked for our input, but it forgot to put a limit on how much input we could give it. It set aside a tiny bucket (a buffer on the stack) to hold our text, but it didn't stop us from pouring an ocean of data into it.

    The Setup: When a function runs, the CPU leaves a "Return Address" (ra) sitting just below that bucket on the stack. This address tells the CPU where to go back to when the function is done.

    The Strategy: We analyzed the assembly to figure out exactly how deep the bucket was. Then, we used Python to generate a massive wave of garbage data (all those 'A's).

    The Kill: We poured enough 'A's into the bucket that it overflowed, spilling perfectly over the CPU's Return Address. We overwrote that Return Address with the exact memory coordinates of the hidden .pass function.

    The Result: The program checked our password, realized it was garbage, and told us we failed. But when the function ended and tried to go home, it read our fake Return Address instead of the real one. The CPU blindly obeyed, jumped straight to the success function, printed "You have passed!", and then violently crashed (Segmentation Fault) because we destroyed the rest of its memory.
