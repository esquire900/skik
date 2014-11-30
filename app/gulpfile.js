// include gulp
var gulp = require('gulp'); 
 
// include plug-ins
var coffee = require('gulp-coffee');
var gutil = require('gulp-util');
var stylus = require('gulp-stylus');
var watch = require('gulp-watch');
var plumber = require('gulp-plumber');
var minifyCss = require('gulp-minify-css');
var minifyHtml = require('gulp-minify-html');
var useref = require('gulp-useref');
var uglify = require('gulp-uglify');
var gulpif = require('gulp-if');
var nib = require('nib');
var fs = require('fs');
var sourcemaps = require('gulp-sourcemaps');
var browserSync = require('browser-sync');
var reload      = browserSync.reload;

// these files are simply (dumb) copied between source and dist, without being processed
var dumbFiles = [
	'robots.txt',
	'.htaccess', 
	'favicon.ico',
	'fonts/**/*',
	'images/**/*',
	'vendor/**/*'
	// 'apple-touch-icon.png'
];

gulp.task('browser-sync', function() {
    browserSync({
        proxy: "localhost/project/newsreader/app/"
    });
});

gulp.task('watch-coffee', function() {
	gulp.src('./app/scripts/**/*.coffee')
	.pipe(watch('./app/scripts/**/*.coffee', function(files) {
		return files
		.pipe(plumber())
		.pipe(sourcemaps.init())
		.pipe(coffee({bare: true}).on('error', gutil.log))
		.pipe(sourcemaps.write())
		.pipe(reload({stream:true}))
		.pipe(gulp.dest('./.tmp/scripts/'));
	}))
	.pipe(gulp.dest('./.tmp/scripts/'));

	gulp.src('./app/scripts/**/*.html')
	.pipe(watch('./app/scripts/**/*.html', function(files) {
		return files
			.pipe(reload({stream:true}));
	}))
	.pipe(gulp.dest('./.tmp/scripts/'));
});


gulp.task('watch-stylus', function() {
	gulp.src('./app/**/*.styl')
	.pipe(watch('./app/**/*.styl', function(files) {
		return files
		.pipe(stylus({use: [nib()]}))
		.pipe(reload({stream:true}))
		.pipe(gulp.dest('./.tmp/'));
	}))
	.pipe(gulp.dest('./.tmp/'))
});

gulp.task('watch-index', function() {
	gulp.src('./app/index.html')
	.pipe(watch('./app/index.html', function(files) {
		fs.readFile('./app/index.html', {encoding: "UTF-8"}, function(err, data){
			data = data.replace(/src="scripts/g, 'src="../.tmp/scripts');
			data = data.replace(/href="styles/g, 'href="../.tmp/styles');
			fs.writeFile('./app/dev.html', data);
		});
		return files
			.pipe(reload({stream:true}));
	}));
});

gulp.task("watch-dumb", function(){
	for (var i = dumbFiles.length - 1; i >= 0; i--) {
		// find path
		var x = dumbFiles[i].split("/");
		var prePath = '';
		if(x.length > 1){
			for (var a = 0; a <= x.length - 1; a++) {
				if(x[a] == "*" || x[a] == "**") break;
				if(a > 0) prePath += "/";
				prePath += x[a];
			};
		}
		gulp.src('./app/'+dumbFiles[i])
			.pipe(gulp.dest('./.tmp/'+prePath));
	};
});


gulp.task('serve', ['watch-coffee','watch-stylus', 'watch-index', 'watch-dumb']);

// =============================================== le building ============================================== //


gulp.task("build-dumb", function(){
	for (var i = dumbFiles.length - 1; i >= 0; i--) {
		// find path
		var x = dumbFiles[i].split("/");
		var prePath = '';
		if(x.length > 1){
			for (var a = 0; a <= x.length - 1; a++) {
				if(x[a] == "*" || x[a] == "**") break;
				if(a > 0) prePath += "/";
				prePath += x[a];
			};
		}
		gulp.src('./app/'+dumbFiles[i])
			.pipe(gulp.dest('./dist/'+prePath));
	};
});

// builds the index: changes all js en css files
gulp.task('build-index', function(){
	var assets = useref.assets();

    return gulp.src('app/*.html')
        .pipe(assets)
        .pipe(gulpif('*.js', uglify({mangle: false})))
        .pipe(gulpif('*.css', minifyCss()))
        .pipe(gulpif('*.html', minifyHtml()))
        .pipe(assets.restore())
        .pipe(useref())
        .pipe(gulp.dest('dist'));
});

gulp.task("build-images", function(){
	gulp.src('./app/images/**/*')
        // .pipe(imagemin())
        .pipe(gulp.dest('./dist/images/'));
});

gulp.task('build-html', function() {
	// dont take index.html
	gulp.src('./app/scripts/**/*.html')
		.pipe(gulp.dest('./dist/scripts/'));
	gulp.src('./app/views/**/*.html')
		.pipe(gulp.dest('./dist/views/'));
});

gulp.task('build', ['build-index', 'build-html', 'build-images', 'build-dumb']);

// ================================================== Other

gulp.task('index', function(){
	var walk = function(dir, done) {
	  var results = [];
	  fs.readdir(dir, function(err, list) {
	    if (err) return done(err);
	    var pending = list.length;
	    if (!pending) return done(null, results);
	    list.forEach(function(file) {
	      file = dir + '/' + file;
	      fs.stat(file, function(err, stat) {
	        if (stat && stat.isDirectory()) {
	          walk(file, function(err, res) {
	            results = results.concat(res);
	            if (!--pending) done(null, results);
	          });
	        } else {
	          results.push(file);
	          if (!--pending) done(null, results);
	        }
	      });
	    });
	  });
	};
	walk('./app/scripts/', function(err, results) {
		var add = [];
		for (var i = results.length - 1; i >= 0; i--) {
			if(results[i].search(".coffee") != -1){
				add.push('<script src="scripts/'+results[i].replace(".coffee", '')+'.js"></script>')
			}
		};
		return watch('./app/index.html', function(files) {
			fs.readFile('./app/index.html', {encoding: "UTF-8"}, function(err, data){
				split = data.split("<!-- build:js(.tmp) scripts/scripts.js -->");
				split2 = split[1].split("<!-- endbuild -->");
				data = split[0];
				data += "<!-- build:js(.tmp) scripts/scripts.js -->\n";
				for (var i = add.length - 1; i >= 0; i--) {
					data += "	"+add[i]+"\n";
				};
				data += "	<!-- endbuild -->\n";
				data += "\n </body></html>";
				data = data.replace(/scripts\/.\/app\/scripts\//g, 'scripts');
				fs.writeFile('./app/index.html', data);
			});
			return files;
		});
	});
});