# Overview
In this NoC design I use a VHDL based methodology to design a NoC system. I Implemented this work in a practical FPGA design 
environment using Quartus-II from Intel and Modelsim. 
# Implementation
## Packet Format
- In packet switching, a packet is broken into multiple bits.
- The first it of the packet is called header flit. It contains the destination address (i.e. routing information) of the packet.
- The last flit of the packet is called tail flit which indicated the end of  transmission for the packet. The actual data of the packet are in the rest  of its which are called payloads
- Each flit is 12 bits, and a packet is 2 flits.
- The rest flits are payload and the two MSBs must be 00.
## Asynchronous Communication
## Crossbar Switch
- The crossbar switch is the final stage of the router.
  It maps the packets coming from the input ports to the assigned output ports.
## FIFO Buffer
- Associated with each input port, an input buffer is used for temporarily storing the incoming flits. The input buffer works on the basis of first in first out (FIFO) mechanism. The input buffer component includes 2 parts, one part which handles the controlling signals and the second part for storing the incoming packets. 
- The reading operation stops when the control signal Credit in coming from Arbiter which indicates that no more space is available in the adjacent.
- However, the storage in the current buffer will continue get new flits until it becomes full.
- The control signal "Credit out" represents as a back pressure to the adjacent source node, when FIFO Buffer becomes full. 
- As soon as the header it reaches to the FIFO, the packet information included in this header it will notify the Arbiter about the arrival of the packet in this port, and provide the destination address to the Routing Unit to calculate the direction
## Arbiter
- In order to move the packets through the switch, an arbiter is used in every router. The arbiter generates arbitration signals to provide synchronous connections between any pair of input ports and output ports of crossbar switches. 
- Once it receives a request from an input port, it sends out the 
routing information to the routing unit and receives the direction 
information.
- Then, the availability of free buffer locations in the neighboring destination router is checked through examining the validity of the signal "Credit in". If it is available, it generates a grant signal to the proper input buffer component and as well as crossbar switch. Is also generates "Write request" signal to the input port of next router.
## Routing Unit
- In order to find the destination output port for a packet in a switch, a routing unit is used. 
- This unit is responsible for obtaining the direction that packet should take based on the address provided by the head it. It receives the address from arbiter unit. 
- Once it receives an address, it decodes the address and generates destination port and send it back to the arbiter unit. 
- It is constructed by some multiplexers to provide the associated output port for the packet.
- We will implement the XY routing algorithm
## Assignments Format
- Files
  - DSD_VHDL_Project : Project description
  - Two_Router_NoC: Directory containing codes











