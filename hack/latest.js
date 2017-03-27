#!/usr/bin/env node
var request = require('request'),
    semver  = require('semver'),
    latest_releases = {
      '0.10': undefined,
      '0.12': undefined,
      '4': undefined,
      '5': undefined,
      '6': undefined,
      '7': undefined};
    
function parse_releases(json_releases){
  var releases = JSON.parse(json_releases);
  var versions = [];
  // group by major release version
  for(var release in releases){
    var release_ver = releases[release]['version'];
    for(var major_version in latest_releases){
      if(semver.satisfies(release_ver, major_version)){
	if( typeof(latest_releases[major_version]) == 'undefined' || 
	    semver.gt(release_ver, latest_releases[major_version])){
          latest_releases[major_version] = semver.clean(release_ver);
	}
      }
    }
  }

  for(var version in latest_releases){
    versions.push(latest_releases[version]);
  }
  console.log(versions.sort().join(' '));
};

request('https://nodejs.org/dist/index.json', function (error, response, body) {
  if (!error && response.statusCode == 200) {
    parse_releases(body)
  }else{
    console.error("Error fetching latest release info from: \nhttps://nodejs.org/dist/index.json")
  }
})
