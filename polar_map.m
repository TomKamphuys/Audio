function polar_map(f, measurementAngles, spl)

  disp('Not correct (yet)');

  spl = spl - repmat(spl(1,:), size(spl, 1), 1);

  spl = [flipud(spl(2:end,:)); spl];
  measurementAngles = [-measurementAngles(end:-1:2) measurementAngles];

  pcolor(f, measurementAngles, spl);
  shading interp
  set(gca,'xscale','log');
  colormap('jet')
  colorbar
  caxis([-30 0])

  hold on

  contour(f, measurementAngles, spl, 'k')

endfunction
