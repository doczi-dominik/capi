STYLE = {
    ACTIONBARBUTTON = {
        bg_color = COLOR.BUTTON_COLOR,
        highlight_color = COLOR.BUTTON_HIGHLIGHT,
        sizeFactor = 1/3,
        alignmet = "+90",
        color = COLOR.BLACK,

        dependencyTable = {},

        onClick = function (self)
            PANELINFO.setChild(PAGES[self.dependencyIndex])
            ROOT.computeLayout() 
        end,

        drawExt = function (self)
            if self.isOn then
                self.w = self.tw + self.parent.padding * 2 
            end
        end,
    },
    STYLEDBUTTON = {
        bg_color = COLOR.BUTTON_COLOR,
        border_color = COLOR.PRIMARY,
        border_size = 3,

    }
}