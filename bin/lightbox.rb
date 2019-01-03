#!/usr/bin/ruby

x = Dir.glob('*.{gif,png,jpeg,jpg}').sort


puts <<EOF
<!DOCTYPE html>
<html lang="en">
    <head>
        <title>test flex</title>
	<style>
	   .modal {
        display: none;
        /* Hidden by default */
        position: fixed;
        /* Stay in place */
        z-index: 1;
        padding-top: 10px;
        padding-bottom: 10px;
        /* needed for animation */
        left: 0;
        top: 0;
        /* Sit on top */
        width: 100%;
        /* Full width */
        height: 100%;
        /* Full height */
        overflow: auto;
        /* Enable scroll if needed */
        background-color: rgb(0, 0, 0);
        /* Fallback color */
        background-color: rgba(0, 0, 0, 0.7);
        /* Black w/ opacity */
    }
    </style>
	</head>
	<body>
        <div id="myModal" class="modal">
            <img id="myPic" src="0032.gif" style="display: block; margin-left: auto; margin-right: auto; height: 100%" />
        </div>
EOF

i = 0
x.each {|fn| puts <<EOF


<IMG width=33% onclick="document.getElementById('myModal').style.display = 'block'; document.getElementById('myPic').src = this.src; document.getElementById('myPic').alt = this.alt;" style='min-height:200px; max-height:400px;' id=#{i} alt=#{i} src='#{fn}'/>

EOF
i = i+1
}

puts <<EOF
	</body>
	  <script  type="text/javascript">
	              // When the user clicks anywhere outside of the modal, close it
            window.onclick = function(event) {
                if (event.target === modal) {
                    modal.style.display = 'none';
                }
            };

            // handy esc,arrowkey browsing
            document.onkeydown = function(event) {
                if (event.keyCode === 27) {
                    // escape

                    document.getElementById('myModal').style.display = 'none';
                } else if (event.keyCode === 39) {
                    // ArrowRight

                    myPic.alt = parseInt(myPic.alt) + 1;
		    myPic.src = document.getElementById(myPic.alt).src;

                    modal.style.display = 'block';

                    console.log('SPG: alt: ' + myPic.alt + ' src: ' + myPic.src);
                } else if (event.keyCode === 37) {
                    // ArrowLeft

                    myPic.alt = parseInt(myPic.alt) - 1;
		    myPic.src = document.getElementById(myPic.alt).src;

                    modal.style.display = 'block';
                    // console.log("SPG: " + event.key + " code: " + event.keyCode)
                }
            };

	  </script>
    </body>

</html>
EOF


