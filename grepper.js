#! /usr/bin/env node

var carrier = require('carrier');
var fs      = require('fs');
var util    = require('util');

function Grepper (args) {
	if (! args) args = {};
	this.is_case_sensitive = 'is_case_sensitive' in args ? !! args['is_case_sensitive'] : true;
	this.is_inverted = !! args['is_inverted'];
	this.pattern = args['pattern'];
	this.show_file_name = !! args['show_file_name'];
	this.show_line_number = !! args['show_line_number'];
};

Grepper.prototype.match = function (in_file) {
	var compiled_pattern = new RegExp(this.pattern, this.is_case_sensitive ? '' : 'i');
	var format = [
		this.show_file_name ? '[%s]:' : '%s',
		this.show_line_number ? '[%d]:' : '%s',
		'%s\n'
	].join('');
	var line_count = 0;

	var line_stream = carrier.carry(fs.createReadStream(in_file));
	line_stream.on('line', function (line) {
		++line_count;
		if (! this.is_inverted !== ! compiled_pattern.test(line)) {
			process.stdout.write(util.format(format,
				this.show_file_name ? in_file : '',
				this.show_line_number ? line_count : '',
				line
			));
		}
	}.bind(this));
};

var file = './grepper.js';
var grepper = new Grepper({
	is_inverted: true,
	is_case_sensitive: false,
	show_file_name: true,
	show_line_number: true,
	pattern: 'grep'
});
grepper.match(file);
