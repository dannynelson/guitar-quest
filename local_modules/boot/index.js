/*
Code that needs to run at the beginning of each process.
This is js file so that mocha can require it for tests.
*/

process.env.TZID = process.env.TZID || 'UTC';
