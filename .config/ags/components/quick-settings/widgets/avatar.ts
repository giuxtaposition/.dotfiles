const Avatar = () => {
  const size = 45;
  const img = "/home/giu/.config/ags/user.jpg";
  return Widget.Box({
    className: "avatar",
    css: `
        min-width: ${size}px;
        min-height: ${size}px;
        background-image: url('${img}');
        background-size: cover;
    `,
  });
};

export default Avatar;
