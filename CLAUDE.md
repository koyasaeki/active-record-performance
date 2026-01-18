# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a Ruby project for benchmarking ActiveRecord/ActiveModel memory usage compared to plain Ruby objects. Uses SQLite in-memory database.

## Development Commands

```bash
# Install dependencies
bundle install

# Run memory benchmark
bundle exec ruby benchmark_memory.rb
```

## Dependencies

- activerecord - ORM with ActiveModel
- sqlite3 - Database backend
- memory_profiler - Memory usage analysis
