<?php

    $img = imagecreatefrompng('./graphics/Font.png');
    $width = imagesx($img);
    $height = imagesy($img);
    echo "Font: $width x $height\n";
    $tiles_dx = intval($width / 8);
    $tiles_dy = intval($height / 8);
    echo "Chars: $tiles_dx x $tiles_dy\n";
    
    // tiles array
    $tilesArray = Array();

    $cur_tile = 0;
    $last_tile = 0;
    
    // scan image and create array
    for ($tiley=0; $tiley<$tiles_dy; $tiley++)
    {
        for ($tilex=0; $tilex<$tiles_dx; $tilex++)
        {
	        $tile = Array();
            $have_data = false;
	        for ($y=0; $y<8; $y++)
            {
                $res = 0; 
		        for ($x=0; $x<8; $x++)
                {
                    $py = $tiley*8 + $y;
		            $px = $tilex*8 + $x;
		            $res = ($res >> 1) & 0x00FFFFFF;
                    $rgb_index = imagecolorat($img, $px, $py);
                    $rgba = imagecolorsforindex($img, $rgb_index);
                    $r = $rgba['red'];
                    $g = $rgba['green'];
                    $b = $rgba['blue'];
		            if ($r > 127) { $res = $res | 0x00800000; }
                    if ($g > 127) { $res = $res | 0x00008000; }
                    if ($b > 127) { $res = $res | 0x00000080; }
                }
                array_push($tile, $res);
                if ($res !== 0) $have_data = true;
            }
	        array_push($tilesArray, $tile);
            $cur_tile++;
            if ($have_data) $last_tile = $cur_tile;
        }
    }
    
    echo "Usable chars count: ".$last_tile."\n";
    
    ////////////////////////////////////////////////////////////////////////////
    
    echo "Writing PPU characters data ...\n";
    $f = fopen ("inc_ppu_font.mac", "w");
    fputs($f, "FontPpuData:\n");
    $n=0;
    for ($t=0; $t<$last_tile; $t++)
    {
	    $tile = $tilesArray[$t];
    	for ($i=0; $i<8; $i++)
	    {
    	    if ($n==0) fputs($f, "\t.byte\t");
	        $bb = ($tile[$i] & 0xFF);
	        fputs($f, decoct($bb));
	        $n++; if ($n<8) fputs($f, ", "); else { $n=0; fputs($f, "\n"); }
        }
    }
    fputs($f, "\n");
    fputs($f, "\t.even\n\n");
    fclose($f);

?>