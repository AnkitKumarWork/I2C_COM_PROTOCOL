`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/26/2024 02:57:53 PM
// Design Name: 
// Module Name: i2c_top
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module i2c_top (
    input wire clk,
    input wire reset,
    input wire start,
    input wire [6:0] address,
    input wire rw,
    inout wire sda,
    output wire scl
);
    wire busy, ack_error;

    i2c_master master (
        .clk(clk),
        .reset(reset),
        .start(start),
        .slave_address(address),
        .rw(rw),
        .sda(sda),
        .scl(scl),
        .busy(busy),
        .ack_error(ack_error)
    );

    i2c_master_0x80 master2 (
        .clk(clk),
        .reset(reset),
        .start(start),
        .address(address),
        .rw(rw),
        .sda(sda),
        .scl(scl),
        .busy(busy),
        .ack_error(ack_error)
    );

    i2c_slave_0x40 slave1 (
        .clk(clk),
        .reset(reset),
        .sda(sda),
        .scl(scl),
        .data_ready(),
        .data_out(),
        .data_in(8'b0)
    );

    i2c_slave_0x60 slave2 (
        .clk(clk),
        .reset(reset),
        .sda(sda),
        .scl(scl),
        .data_ready(),
        .data_out(),
        .data_in(8'b0)
    );
endmodule
