module.exports = {
  preset: 'ts-jest',
  testEnvironment: 'node',
  verbose: true,
  testMatch: ['**/*.test.ts'],
  collectCoverage: true,
  collectCoverageFrom: [
    'src/**/*.ts',
    '!src/index.ts', // Usually triggers are hard to cover fully in unit tests without integration, but user asked for coverage. I will include everything for now or explicit excludes if needed.
    '!src/**/*.d.ts'
  ],
  coverageDirectory: 'coverage',
  globals: {
    'ts-jest': {
      tsconfig: 'tsconfig.json'
    }
  },
  transformIgnorePatterns: [
    "node_modules/(?!(@turf|geofire-common|kdbush)/)"
  ]
};
