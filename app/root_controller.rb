class RootController < UIViewController

  def loadView
    self.view = UIView.alloc.initWithFrame(UIScreen.mainScreen.applicationFrame)
    self.view.autoresizesSubviews = true

    # add UITableView as a subview
    tableView = UITableView.alloc.initWithFrame(self.view.bounds, style:UITableViewStylePlain)
    tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight
    tableView.dataSource = self
    tableView.delegate = self
    self.view.addSubview(tableView)
  end

  def viewDidLoad
    self.navigationItem.title = "Fonts"
  end

  # Table View 
  def numberOfSectionsInTableView(tableView)
    return font_dictionary_array.count
  end

  def tableView(tableView, titleForHeaderInSection:section)
    font_dict = font_dictionary_array[section]
    return font_dict[:family]
  end

  def sectionIndexTitlesForTableView(tableView)
    font_dictionary_array.map do |e|
      e[:family].slice(0)
    end.uniq
  end

  def tableView(tableView, sectionForSectionIndexTitle:title, atIndex:index)
    font_dictionary_array.map do |e|
      e[:family].slice(0)
    end.index(title)
  end

  def tableView(tableView, numberOfRowsInSection:section)
    font_dict = font_dictionary_array[section]
    return font_dict[:fonts].count
  end

  CELLID = "fonts"
  def tableView(tableView, cellForRowAtIndexPath:indexPath)
    cell = tableView.dequeueReusableCellWithIdentifier(CELLID) || begin
      cell = UITableViewCell.alloc.initWithStyle(UITableViewCellStyleDefault, reuseIdentifier:CELLID)
      cell.selectionStyle = UITableViewCellSelectionStyleBlue
      cell
    end

    font_dict = font_dictionary_array[indexPath.section]
    font_name = font_dict[:fonts][indexPath.row]
    cell.textLabel.font = UIFont.fontWithName(font_name, size:18)
    cell.textLabel.text = font_name
    return cell
  end

  def tableView(tableView, didSelectRowAtIndexPath:indexPath)
    font_dict = font_dictionary_array[indexPath.section]
    font_name = font_dict[:fonts][indexPath.row]

    puts font_name
    detail_controller = DetailController.alloc.init
    detail_controller.navigationItem.title = "Sample Text"
    detail_controller.selected_font(font_name)
    self.navigationController.pushViewController(detail_controller, animated:true)

    tableView.deselectRowAtIndexPath(indexPath, animated:true)
  end

  def font_dictionary_array
    result_array = []
    UIFont.familyNames.sort.each do |e|
      # puts e
      fonts = []
      UIFont.fontNamesForFamilyName(e).sort.each do |f|
        # puts "- #{f}"
        fonts << f
      end
      result_array << {:family => e, :fonts => fonts}
    end

    return result_array
  end

end
